################################################################################
# SPDX-FileCopyrightText: Copyright (c) 2024 Levi Pereira. All rights reserved.
# SPDX-License-Identifier: Apache 2.0
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
################################################################################



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
