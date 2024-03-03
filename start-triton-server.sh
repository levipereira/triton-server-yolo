#!/bin/bash

# Script to convert ONNX models to TensorRT engines and start NVIDIA Triton Inference Server.

# Usage:
# ./start-triton-server.sh [--models <models>] [--efficient_nms <enable/disable>] [--opt_batch_size <number>] [--max_batch_size <number>] [--instance_group <number>] [--force]

# - Use --models to specify the YOLO model name. Choose from 'yolov9-c', 'yolov9-e', 'yolov7', 'yolov7x'.
# - Use --efficient_nms to enable or disable TRT Efficient NMS plugin. Options: 'enable' or 'disable'.
# - Use --opt_batch_size to specify the optimal batch size for TensorRT engines.
# - Use --max_batch_size to specify the maximum batch size for TensorRT engines.
# - Use --instance_group to specify the number of TensorRT engine instances loaded per model in the Triton Server.
# - Use --force to rebuild TensorRT engines even if they already exist.

usage() {
    echo "Usage: $0 [--models <models>] [--efficient_nms <enable/disable>] [--opt_batch_size <number>] [--max_batch_size <number>] [--instance_group <number>] [--force]"
    echo "  - Use --models to specify the YOLO model name. Choose from 'yolov9-c', 'yolov9-e', 'yolov7', 'yolov7x'."
    echo "  - Use --efficient_nms to enable or disable TRT Efficient NMS plugin. Options: 'enable' or 'disable'."
    echo "  - Use --opt_batch_size to specify the optimal batch size for TensorRT engines."
    echo "  - Use --max_batch_size to specify the maximum batch size for TensorRT engines."
    echo "  - Use --instance_group to specify the number of TensorRT engine instances loaded per model in the Triton Server."
    echo "  - Use --force to rebuild TensorRT engines even if they already exist."
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
force_build=false
model_onnx_end2end=true
efficient_nms=""
model_names=()

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --force)
            force_build=true
            shift
            ;;
        --models)
            IFS=',' read -r -a model_names <<< "$2"
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
            opt_batch_size="$2"
            shift 2
            ;;
        --max_batch_size)
            max_batch_size="$2"
            shift 2
            ;;
        --instance_group)
            instance_group="$2"
            shift 2
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

# Check if all required parameters are provided
if [[ -z $opt_batch_size || -z $max_batch_size || -z $instance_group ]]; then
    usage
    exit 1
fi

# Check if force flag is set
if [[ "$force_build" == true ]]; then
    echo "Force build enabled. TensorRT engines will be rebuilt."
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
    trt_dir=./models_trt
    mkdir -p $trt_dir
    
    if [[ $efficient_nms == "enable" ]]; then
        onnx_file=./models_onnx/$model_name-end2end.onnx
        trt_file=$trt_dir/$model_name-end2end.engine
        download_model=$model_name-end2end
    else
        onnx_file=./models_onnx/$model_name.onnx
        trt_file=$model_trt/$model_name.engine
        download_model=$model_name
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

    if [[ $force_build == true || ! -f $trt_file ]]; then
        /usr/src/tensorrt/bin/trtexec \
            --onnx="$onnx_file" \
            --minShapes=images:1x3x640x640 \
            --optShapes=images:${opt_batch_size}x3x640x640 \
            --maxShapes=images:${max_batch_size}x3x640x640 \
            --fp16 \
            --workspace="$workspace" \
            --saveEngine="$trt_file"  

        if [[ $? -ne 0 ]]; then
            echo "Conversion of $model_name ONNX model to TensorRT engine failed"
            exit 1
        fi
    fi
done

# Update Triton server configuration files
for model_name in "${model_names[@]}"; do
    model_dir=./models/$model_name
    mkdir -p $model_dir/1/
    
    trt_dir=./models_trt
    if [[ $efficient_nms == "enable" ]]; then
        if [[ $model_name == *"yolov7"* ]]; then
            model_config_template=./models_config/yolov7_onnx_end2end.pbtxt
        fi
        if [[ $model_name == *"yolov9"* ]]; then
            model_config_template=./models_config/yolov9_onnx_end2end.pbtxt
        fi
        trt_file=$trt_dir/$model_name-end2end.engine
    else
        if [[ $model_name == *"yolov7"* ]]; then
            model_config_template=./models_config/yolov7_onnx.pbtxt
        fi
        if [[ $model_name == *"yolov9"* ]]; then
            model_config_template=./models_config/yolov9_onnx.pbtxt
        fi
        trt_file=$model_trt/$model_name.engine
    fi

    cp $trt_file $model_dir/1/model.plan
    
    config_file="./models/$model_name/config.pbtxt"

    cp "$model_config_template" "$config_file"
    sed -i "s/model_template_name/$model_name/g" "$config_file"
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
