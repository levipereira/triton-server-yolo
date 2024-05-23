#!/bin/bash

arch=$(uname -m)

if [ "$arch" == "x86_64" ]; then
    TRT_INSTALL_LIBPATH=/usr/lib/$arch-linux-gnu
else
    echo "$arch not supported yet."
    exit 1
fi

download_library() {
    local url="https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/libnvinfer_plugin.so.8.6.1"
    echo "Downloading libnvinfer_plugin.so.8.6.1 from $url"
    curl -L -o libnvinfer_plugin.so.8.6.1 "$url"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download libnvinfer_plugin.so.8.6.1"
        exit 1
    fi
}

if [ "$1" == "--download" ]; then
    download_library
fi

if [ ! -f "./libnvinfer_plugin.so.8.6.1" ]; then
    echo "Error: libnvinfer_plugin.so.8.6.1 not found. Build or download it with flag --download"
    exit 1
fi

if [ -f "$TRT_INSTALL_LIBPATH/libnvinfer_plugin.so.8.6.1" ]; then
    cp $TRT_INSTALL_LIBPATH/libnvinfer_plugin.so.8.6.1 "./libnvinfer_plugin.so.8.6.1.ori.bak"
    echo "Original libnvinfer_plugin.so.8.6.1 was copied to ./libnvinfer_plugin.so.8.6.1.ori.bak"
fi

cp $(pwd)/libnvinfer_plugin.so.8.6.1 $TRT_INSTALL_LIBPATH/libnvinfer_plugin.so.8.6.1

ldconfig
echo "libnvinfer_plugin.so.8.6.1 has been installed successfully."
