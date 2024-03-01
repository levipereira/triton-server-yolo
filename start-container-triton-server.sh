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