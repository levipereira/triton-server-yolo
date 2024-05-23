#!/bin/bash
arch=$(uname -m)

if [ "$arch" == "x86_64" ]; then
    TRT_INSTALL_LIBPATH=/usr/lib/$arch-linux-gnu
else
    echo "$arch not supported yet."
    exit
fi

# Check if libnvinfer_plugin.so.8.6.1 exists in the current directory
if [ ! -f "./libnvinfer_plugin.so.8.6.1" ]; then
    echo "Error: Build or download libnvinfer_plugin.so.8.6.1"
    exit 1
fi

# Backup original libnvinfer_plugin.so.x.y
if [ -f "$TRT_INSTALL_LIBPATH/libnvinfer_plugin.so.8.6.1" ]; then
    cp $TRT_INSTALL_LIBPATH/libnvinfer_plugin.so.8.6.1 "./libnvinfer_plugin.so.8.6.1.ori.bak"
fi

cp $(pwd)/libnvinfer_plugin.so.8.6.1 $TRT_INSTALL_LIBPATH/libnvinfer_plugin.so.8.6.1

# Update library cache
ldconfig
echo "libnvinfer_plugin.so.8.6.1 has been installed successfully."
echo "Original libnvinfer_plugin.so.8.6.1 was copied to ./libnvinfer_plugin.so.8.6.1.ori.bak"