#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <model_name>"
    exit 1
fi

# Model name from command line argument
model_name="$1"

# Download YOLOv7 ONNX model
echo "Downloading ONNX model $model_name..."
wget "https://github.com/levipereira/triton-server-yolo-v7-v9/releases/download/v0.0.1/$model_name.onnx"

# Check if download was successful
if [[ $? -eq 0 ]]; then
    echo "ONNX model $model_name downloaded successfully to $destination_dir."
else
    echo "Failed to download ONNX model $model_name."
    exit 1
fi
