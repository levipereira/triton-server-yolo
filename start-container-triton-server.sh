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

# Script to run NVIDIA Triton Inference Server container with Docker.

# Usage:
# Run this script to start the Triton Inference Server container.

# Prerequisites:
# - NVIDIA Docker must be installed.
# - NVIDIA GPU(s) should be available.

# Script Options:
#   --gpus all: Enables access to all available GPUs by the container.
#   --name triton-server-23.08: Assigns a name to the running container.
#   --rm: Automatically removes the container when it exits.
#   -it: Launches the container interactively.
#   --ipc=host: Shares the host system's IPC namespace with the container.
#   --shm-size=2g: Sets the size of /dev/shm in the container.
#   --ulimit memlock=-1: Removes the memory locking limit.
#   --ulimit stack=67108864: Sets the stack size limit.
#   -p8000:8000, -p8001:8001, -p8002:8002: Maps ports 8000, 8001, and 8002 of the host to the same ports in the container.
#   -v $(pwd):/apps: Mounts the current working directory to /apps directory in the container.
#   -w /apps: Sets the working directory inside the container to /apps.
#   nvcr.io/nvidia/tritonserver:23.08-py3: Specifies the Docker image to use.

docker run --gpus all \
 --name triton-server-23.08 \
 --rm \
 -it \
 --ipc=host \
 --shm-size=2g \
 --ulimit memlock=-1 \
 --ulimit stack=67108864 \
 -p8000:8000 \
 -p8001:8001 \
 -p8002:8002 \
 -v $(pwd):/apps \
 -w /apps  \
 nvcr.io/nvidia/tritonserver:23.08-py3
