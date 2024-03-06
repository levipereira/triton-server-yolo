#!/bin/bash

# Script to convert ONNX models to TensorRT engines and start NVIDIA Triton Inference Server.

# Usage:
# ./start-triton-server.sh [--models <models>] [--efficient_nms <enable/disable>] [--opt_batch_size <number>] [--max_batch_size <number>] [--instance_group <number>] 
 

usage() {
    echo "Usage: $0 [--models <models>] [--model_mode <eval/inference>]  [--efficient_nms <enable/disable>] [--opt_batch_size <number>] [--max_batch_size <number>] [--instance_group <number>] [--force] [--reset_all]"
    echo "  - Use --models to specify the YOLO model name. Choose one or more with comma separated. yolov9-c,yolov9-e,yolov7,yolov7-qat,yolov7x,yolov7x-qat"
    echo "  - Use --model_mode - Model was optimized for EVALUATION and INFERENCE. Choose from 'eval' or 'inference'"
    echo "  - Use --efficient_nms to enable or disable TRT Efficient NMS plugin. Options: 'enable' or 'disable'."
    echo "  - Use --opt_batch_size to specify the optimal batch size for TensorRT engines."
    echo "  - Use --max_batch_size to specify the maximum batch size for TensorRT engines."
    echo "  - Use --instance_group to specify the number of TensorRT engine instances loaded per model in the Triton Server."
    echo "  - Use --force Rebuild TensorRT engines even if they already exist."
    echo "  - Use --reset_all Purge all existing TensorRT engines and their respective configurations."
}

function check_model() {
    local model_names=("yolov9-c" "yolov9-e" "yolov7" "yolov7-qat" "yolov7x" "yolov7x-qat")
    for model in "${model_names[@]}"; do
        if [[ "$1" == "$model" ]]; then
            return 0
        fi
    done
    return 1
}


# Function to calculate the available GPU memory
function get_free_gpu_memory() {
    # Get the total memory and used memory from nvidia-smi
    local total_memory=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | awk '{print $1}')
    local used_memory=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | awk '{print $1}')

    # Calculate free memory
    local free_memory=$((total_memory - used_memory))
    echo "$free_memory"
}

# Default values
max_batch_size=""
opt_batch_size=""
instance_group=""
model_onnx_end2end=true
efficient_nms=""
force_build=false
reset_all=false
model_mode=""
model_names=()

if [[ $# -eq 0 ]]; then
    usage
    exit 0
fi



# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --reset_all)
            reset_all=true
            break
            ;;
        --force)
            force_build=true
            shift
            ;;
        --models)
            IFS=',' read -r -a model_names <<< "$2"
            for model in "${model_names[@]}"; do
                if ! check_model "$model"; then
                    echo "Invalid model name: $model"
                    usage
                    exit 1
                fi
            done
            shift 2
            ;;
        --model_mode)
            model_mode="$2"
            if [[ "$model_mode" != "eval" && "$model_mode" != "inference" ]]; then
                echo "Invalid value for --model_mode. Choose 'eval' or 'inference'."
                exit 1
            fi
            shift 2
            ;;
        --efficient_nms)
            efficient_nms="$2"
            if [[ "$efficient_nms" != "enable" && "$efficient_nms" != "disable" ]]; then
                echo "Invalid value for --efficient_nms. Choose 'enable' or 'disable'."
                exit 1
            fi
            shift 2
            ;;
        --opt_batch_size)
            if [[ ! "$2" =~ ^[0-9]+$ || "$2" -le 0 ]]; then
                echo "Invalid value for --opt_batch_size. Must be a positive integer."
                exit 1
            fi
            opt_batch_size="$2"
            shift 2
            ;;
        --max_batch_size)
            if [[ ! "$2" =~ ^[0-9]+$ || "$2" -le 0 ]]; then
                echo "Invalid value for --max_batch_size. Must be a positive integer."
                exit 1
            fi
            max_batch_size="$2"
            shift 2
            ;;
        --instance_group)
            if [[ ! "$2" =~ ^[0-9]+$ || "$2" -le 0 ]]; then
                echo "Invalid value for --instance_group. Must be a positive integer."
                exit 1
            fi
            instance_group="$2"
            shift 2
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done


# Check if reset_all is true
if $reset_all; then
    # Ask user for confirmation
    read -p "Are you sure you want to delete engines models files generated in ./models/? (y/n) " confirm

    # Check user's response
    if [[ $confirm == [Yy] ]]; then
        # Delete files
        rm -rf ./models/*
        echo "Model engines/configuration was reseted. Please re-run without --reset-all flag."
        exit 0
    else
        echo "Operation canceled by the user."
        exit 0
    fi
fi


# Calculate workspace size based on free GPU memory
workspace=$(get_free_gpu_memory)

# Model ONNX end2end flag
if [[ "$model_onnx_end2end" == true ]]; then
    model_config_template="./models_config/yolo_onnx_end2end.pbtxt"
else
    model_config_template="./models_config/yolov9_onnx.pbtxt"
fi

# Model List
if [[ ${#model_names[@]} -eq 0 ]]; then
    model_names=("yolov9-c" "yolov9-e" "yolov7" "yolov7x")
fi



# Convert ONNX models to TensorRT engines
for model_name in "${model_names[@]}"; do
    model_dir=./models/$model_name/1
    mkdir -p $model_dir

    if [[ $model_mode == "eval" && $efficient_nms == "enable" ]]; then
        onnx_file=./models_onnx/eval-${model_name}-end2end.onnx
        trt_file=${model_dir}/eval-end2end-${model_name}-max-batch-${max_batch_size}.engine
        file_pattern="${model_dir}/eval-end2end-${model_name}-max-batch-*.engine"
        download_model=eval-${model_name}-end2end
    fi

    if [[ $model_mode == "inference" && $efficient_nms == "enable" ]]; then
        onnx_file=./models_onnx/infer-${model_name}-end2end.onnx
        trt_file=${model_dir}/infer-end2end-${model_name}-max-batch-${max_batch_size}.engine
        file_pattern="${model_dir}/infer-end2end-${model_name}-max-batch-*.engine"
        download_model=infer-${model_name}-end2end
    fi

    if [[ $model_mode == "inference" && $efficient_nms == "disable" ]]; then
        if [[ $model_name == *"qat"* ]]; then
            echo "Model '$model_name' without '--efficient_nms enable' is not supported yet."
            exit 1
        fi
        onnx_file=./models_onnx/infer-${model_name}.onnx
        trt_file=${model_dir}/infer-${model_name}-max-batch-${max_batch_size}.engine
        file_pattern="${model_dir}/infer-${model_name}-max-batch-*.engine"
        download_model=infer-${model_name}
    fi

    if [[ $model_mode == "eval" && $efficient_nms == "disable" ]]; then
        echo "Not Supported EVALUATION without Efficient NMS. Only INFERENCE is supported to perfomance latency testing purpose. "
        exit 1
    fi
 

    if [[ ! -f "$onnx_file" ]]; then
        cd ./models_onnx || exit 1
        bash ./download_models.sh $download_model
        cd ../ || exit 1
    fi

    if [[ ! -f "$onnx_file" ]]; then
         echo " $model_name  ONNX model file not found: $onnx_file"
         exit 1
     fi

    build_file=false
    file_count=0

    for existing_file in $file_pattern; do
        if [[ -f "$existing_file" ]]; then
            echo $existing_file
            existing_batch_size=$(echo "$existing_file" | sed -n 's/.*max-batch-\([0-9]*\).*/\1/p')
            if [[ ! "$max_batch_size" -gt "$existing_batch_size" ]]; then
                ((file_count++))
            fi
        fi
    done



    if [[ $file_count -eq 0 ]]; then
        build_file=true
    fi

    if $build_file || $force_build; then
        if [[ $model_name == *"qat"* ]]; then
            /usr/src/tensorrt/bin/trtexec \
                --onnx="$onnx_file" \
                --minShapes=images:1x3x640x640 \
                --optShapes=images:${opt_batch_size}x3x640x640 \
                --maxShapes=images:${max_batch_size}x3x640x640 \
                --fp16 \
                --int8 \
                --workspace="$workspace" \
                --saveEngine="$trt_file" \
                --timingCacheFile="$model_dir/.timing.cache"
        else
            /usr/src/tensorrt/bin/trtexec \
                --onnx="$onnx_file" \
                --minShapes=images:1x3x640x640 \
                --optShapes=images:${opt_batch_size}x3x640x640 \
                --maxShapes=images:${max_batch_size}x3x640x640 \
                --fp16 \
                --workspace="$workspace" \
                --saveEngine="$trt_file" \
                --timingCacheFile="$model_dir/.timing.cache"
        fi
        if [[ $? -ne 0 ]]; then
            echo "Conversion of $model_name ONNX model to TensorRT engine failed"
            exit 1
        fi
    fi
done

# Update Triton server configuration files
for model_name in "${model_names[@]}"; do
    
    model_dir=./models/$model_name/1
    

    if [[ $efficient_nms == "enable" ]]; then
        if [[ $model_name == *"yolov7"* ]]; then
            model_config_template=./models_config/yolov7_onnx_end2end.pbtxt
        fi
        if [[ $model_name == *"yolov9"* ]]; then
            model_config_template=./models_config/yolov9_onnx_end2end.pbtxt
        fi
        
        if [[ $model_mode == "eval" ]]; then
            trt_file=eval-end2end-${model_name}-max-batch-${max_batch_size}.engine
            file_pattern="$model_dir/eval-end2end-${model_name}-max-batch-*.engine"
        fi
        if [[ $model_mode == "inference" ]]; then
            trt_file=infer-end2end-${model_name}-max-batch-${max_batch_size}.engine
            file_pattern="$model_dir/infer-end2end-${model_name}-max-batch-*.engine"
        fi
       
    else
        if [[ $model_name == *"yolov7"* ]]; then
            model_config_template=./models_config/yolov7_onnx.pbtxt
        fi
        if [[ $model_name == *"yolov7x"* ]]; then
            model_config_template=./models_config/yolov7x_onnx.pbtxt
        fi
        if [[ $model_name == *"yolov9"* ]]; then
            model_config_template=./models_config/yolov9_onnx.pbtxt
        fi
        if [[ $model_mode == "inference" ]]; then
            trt_file=infer-${model_name}-max-batch-${max_batch_size}.engine
            file_pattern="$model_dir/infer-${model_name}-max-batch-*.engine"
        fi
        
    fi

    config_file="./models/$model_name/config.pbtxt"

    cp "$model_config_template" "$config_file"
    if [[ $model_mode == "eval" ]]; then
        sed -i "s/TOPK/300/g" "$config_file"
        echo "Configured Topk-all 300 in $config_file"
    fi
    if [[ $model_mode == "inference" ]]; then
        sed -i "s/TOPK/100/g" "$config_file"
        echo "Configured Topk-all 100 in $config_file"
    fi

    closest_batch_size=9999
    for existing_file in $file_pattern; do
        if [[ -f "$existing_file" ]]; then
            existing_batch_size=$(echo "$existing_file" | sed -n 's/.*max-batch-\([0-9]*\).*/\1/p')

           if [[ ! "$max_batch_size" -gt "$existing_batch_size" ]]; then
                if [[ "$closest_batch_size" -gt "$existing_batch_size" ]]; then
                    closest_batch_size=$existing_batch_size
                    trt_file=$(basename "$existing_file")
                fi
            fi
        fi
    done

 


    sed -i "s/model_template_name/$model_name/g" "$config_file"
    sed -i "s/model_template_file/$trt_file/g" "$config_file"
    sed -i "s/max_batch_size: [0-9]*/max_batch_size: $max_batch_size/" "$config_file"
    echo "max_batch_size updated to $max_batch_size in $config_file"
    sed -i "s/count: [0-9]*/count: $instance_group/" "$config_file"
    echo "instance_group updated to $instance_group in $config_file"
done

# Start Triton Inference Server with the converted models
/opt/tritonserver/bin/tritonserver \
    --trace-config triton,file=/apps/trace.json \
    --trace-config triton,log-frequency=50 \
    --trace-config rate=100 \
    --trace-config level=TIMESTAMPS \
    --trace-config count=100  \
    --model-repository=/apps/models \
    --disable-auto-complete-config \
    --log-verbose=0
