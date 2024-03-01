#!/bin/bash

# Create directories if they do not exist
mkdir -p ./yolov7
mkdir -p ./yolov9-e
mkdir -p ./yolov9-c

# Download YOLOv7 ONNX model
echo "Downloading YOLOv7 ONNX model..."
wget -O ./yolov7/yolov7_end2end.onnx https://github.com/levipereira/Docker-Yolov7-Nvidia-Kit/releases/download/v1.0/yolov7_end2end.onnx
# Check if download was successful
if [[ $? -eq 0 ]]; then
    echo "YOLOv7 ONNX model downloaded successfully."
else
    echo "Failed to download YOLOv7 ONNX model."
    exit 1
fi

# Download YOLOv9-E ONNX model
echo "Downloading YOLOv9-E ONNX model..."
wget -O ./yolov9-e/yolov9-e_end2end.onnx https://github.com/levipereira/yolov9/releases/download/v0.2/yolov9-e-end2end.onnx
# Check if download was successful
if [[ $? -eq 0 ]]; then
    echo "YOLOv9-E ONNX model downloaded successfully."
else
    echo "Failed to download YOLOv9-E ONNX model."
    exit 1
fi

# Download YOLOv9-c
echo "Downloading YOLOv9-C ONNX model..."
wget -O ./yolov9-c/yolov9-c_end2end.onnx https://github.com/levipereira/yolov9/releases/download/v0.2/yolov9-c-end2end.onnx
# Check if download was successful
if [[ $? -eq 0 ]]; then
    echo "YOLOv9-C  ONNX model downloaded successfully."
else
    echo "Failed to download YOLOv9-C  ONNX model."
    exit 1
fi



