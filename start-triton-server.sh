#!/bin/bash

# Script to convert ONNX models to TensorRT engines and start NVIDIA Triton Inference Server.

# Usage:
# ./start-triton-server.sh <max_batch_size> <opt_batch_size> <instance_group> [--force]
# - max_batch_size: Maximum batch size for TensorRT engines.
# - opt_batch_size: Optimal batch size for TensorRT engines.
# - instance_group: Number of TensorRT engine instances loaded per model in the Triton Server.
# - Use the flag --force-build to rebuild TensorRT engines even if they already exist.

# Prerequisites:
# - NVIDIA TensorRT must be installed.
# - NVIDIA Triton Inference Server must be installed and configured.

usage() {
    echo "Usage: $0 <max_batch_size> <opt_batch_size> <instance_group> [--force]"
    echo "  - max_batch_size: Maximum batch size for TensorRT engines."
    echo "  - opt_batch_size: Optimal batch size for TensorRT engines."
    echo "  - instance_group: Number of TensorRT engine instances loaded per model in the Triton Server."
    echo "  - Use the flag --force to rebuild TensorRT engines even if they already exist."
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

# Script Flow:

if [ $# -lt 3 ]; then
    usage
    exit 1
fi

max_batch_size="$1"
opt_batch_size="$2"
instance_group="$3"

# Validate input parameters
if [[ -z $max_batch_size || -z $opt_batch_size ]]; then
    usage
    exit 1
fi


if [[ ! -f "./models_onnx/yolov9-c/yolov9-c_end2end.onnx" ]]; then
    echo "YOLOv9-C ONNX model files not found. Attempting to download..."
    cd ./models_onnx || exit 1
    bash ./download_models.sh
    cd ../ || exit 1
fi


if [[ ! -f "./models_onnx/yolov7/yolov7_end2end.onnx" ]]; then
    echo "YOLOv7 ONNX model files not found. Attempting to download..."
    cd ./models_onnx || exit 1
    bash ./download_models.sh
    cd ../ || exit 1
fi

if [[ ! -f "./models_onnx/yolov9-e/yolov9-e_end2end.onnx" ]]; then
    echo "YOLOv7 QAT ONNX model files not found. Attempting to download..."
    cd ./models_onnx || exit 1
    bash ./download_models.sh
    cd ../ || exit 1
fi

# Check if ONNX model files exist
if [[ ! -f "./models_onnx/yolov9-e/yolov9-e_end2end.onnx" ]]; then
    echo "YOLOv7 QAT ONNX model file not found: ./models_onnx/yolov9-e/yolov9-e_end2end.onnx"
    exit 1
fi

if [[ ! -f "./models_onnx/yolov7/yolov7_end2end.onnx" ]]; then
    echo "YOLOv7 ONNX model file not found: ./models_onnx/yolov7/yolov7_end2end.onnx"
    exit 1
fi

# Check if ONNX model files exist
if [[ ! -f "./models_onnx/yolov9-c/yolov9-c_end2end.onnx" ]]; then
    echo "YOLOv9  ONNX model file not found: ./models_onnx/yolov9/yolov9-c_end2end.onnx"
    exit 1
fi
  


# Check if force flag is set
force_build=false

if [[ "$3" == "--force" ]]; then
    force_build=true
fi

# Calculate workspace size based on free GPU memory
workspace=$(get_free_gpu_memory)

mkdir -p ./models/yolov9-c/1/
mkdir -p ./models/yolov7/1/
mkdir -p ./models/yolov9-e/1/

# Convert YOLOv9-c ONNX model to TensorRT engine with FP16 precision if force flag is set or model does not exist
if [[ $force_build == true || ! -f "./models/yolov9-c/1/model.plan" ]]; then
    /usr/src/tensorrt/bin/trtexec \
        --onnx=./models_onnx/yolov9-c/yolov9-c_end2end.onnx \
        --minShapes=images:1x3x640x640 \
        --optShapes=images:${opt_batch_size}x3x640x640 \
        --maxShapes=images:${max_batch_size}x3x640x640 \
        --fp16 \
        --workspace=$workspace \
        --saveEngine=./models/yolov9-c/1/model.plan

    # Check return code of trtexec
    if [[ $? -ne 0 ]]; then
        echo "Conversion of YOLOv9 ONNX model to TensorRT engine failed"
        exit 1
    fi
fi


if [[ $force_build == true || ! -f "./models/yolov7/1/model.plan" ]]; then
    /usr/src/tensorrt/bin/trtexec \
        --onnx=./models_onnx/yolov7/yolov7_end2end.onnx \
        --minShapes=images:1x3x640x640 \
        --optShapes=images:${opt_batch_size}x3x640x640 \
        --maxShapes=images:${max_batch_size}x3x640x640 \
        --fp16 \
        --workspace=$workspace \
        --saveEngine=./models/yolov7/1/model.plan

    # Check return code of trtexec
    if [[ $? -ne 0 ]]; then
        echo "Conversion of YOLOv7 ONNX model to TensorRT engine failed"
        exit 1
    fi
fi


if [[ $force_build == true || ! -f "./models/yolov9-e/1/model.plan" ]]; then
    /usr/src/tensorrt/bin/trtexec \
        --onnx=./models_onnx/yolov9-e/yolov9-e_end2end.onnx \
        --minShapes=images:1x3x640x640 \
        --optShapes=images:${opt_batch_size}x3x640x640 \
        --maxShapes=images:${max_batch_size}x3x640x640 \
        --fp16 \
        --workspace=$workspace \
        --saveEngine=./models/yolov9-e/1/model.plan

    # Check return code of trtexec
    if [[ $? -ne 0 ]]; then
        echo "Conversion of YOLOv9-e ONNX model to TensorRT engine failed"
        exit 1
    fi
fi


### Deploy proto config File.
config_file=./models/yolov9-c/config.pbtxt
if [[ ! -f "$config_file" ]]; then
    cp ./models_config/yolov9-c/config.pbtxt "$config_file"
fi
sed -i "s/max_batch_size: [0-9]*/max_batch_size: $max_batch_size/" "$config_file"
echo "max_batch_size updated to $max_batch_size in $config_file"
sed -i "s/count: [0-9]*/count: $instance_group/" "$config_file"
echo "instance_group updated to $instance_group in $config_file"

config_file=./models/yolov7/config.pbtxt
if [[ ! -f "$config_file" ]]; then
    cp ./models_config/yolov7/config.pbtxt "$config_file"
fi
sed -i "s/max_batch_size: [0-9]*/max_batch_size: $max_batch_size/" "$config_file"
echo "max_batch_size updated to $max_batch_size in $config_file"
sed -i "s/count: [0-9]*/count: $instance_group/" "$config_file"
echo "instance_group updated to $instance_group in $config_file"

config_file=./models/yolov9-e/config.pbtxt
if [[ ! -f "$config_file" ]]; then
    cp ./models_config/yolov9-e/config.pbtxt "$config_file"
fi
sed -i "s/max_batch_size: [0-9]*/max_batch_size: $max_batch_size/" "$config_file"
echo "max_batch_size updated to $max_batch_size in $config_file"
sed -i "s/count: [0-9]*/count: $instance_group/" "$config_file"
echo "instance_group updated to $instance_group in $config_file"


# Start Triton Inference Server with the converted models
/opt/tritonserver/bin/tritonserver \
    --model-repository=/apps/models \
    --disable-auto-complete-config \
    --log-verbose=0
