# Triton Server  YOLOv7 / YOLOv9-C /YOLOv9-E 

This repository serves as an example of deploying the Models YOLOv7 model (FP16), YOLOv9-C and the YOLOv9-E on Triton-Server for performance and testing. It includes support for applications developed using Nvidia DeepStream. 


This repository utilizes exported models using ONNX with the Efficient NMS plugin enabled to generate TensorRT engines.

Users can either build ONNX files themselves  or simply utilize the [start-container-triton-server.sh](start-container-triton-server.sh) script to initiate the container and use [start-triton-server.sh](start-triton-server.sh) to automatically download the models, generate the TRT engine, and start the Triton Server.

## ONNX Models Directory

If users build the ONNX models themselves, they should place the models in this directory with the following structure:
```bash
models_onnx/
├── yolov7
│   └── yolov7_end2end.onnx
├── yolov9-c
│   └── yolov9-c_end2end.onnx
└── yolov9-e
    └── yolov9-e_end2end.onnx
```

## Manual ONNX YOLOv7/v9 exports
### Exporting from PyTorch (YOLOv7 FP16) to ONNX With Efficient NMS plugin
This repo does not export pytorch models to ONNX. <br>
You can use the [Yolov7 Repository](https://github.com/WongKinYiu/yolov7) or the [Yolov7 Docker Image](https://github.com/levipereira/docker_images/tree/master/yolov7) for your convenience.

``` bash 
python export.py --weights yolov7.pt \
  --grid \
  --end2end \
  --dynamic-batch \
  --simplify \
  --topk-all 100 \
  --iou-thres 0.65 \
  --conf-thres 0.35 \
  --img-size 640 640
```

### Exporting from PyTorch (YOLOv9-C/E )  to ONNX With Efficient NMS plugin
This repo does not export pytorch models to ONNX. <br>
You can use this repo [Yolov9 ](https://github.com/levipereira/yolov9)  

``` bash 
python3 export.py \
   --weights ./yolov9-c.pt \
   --imgsz 640 \
   --simplify \
   --topk-all 100 \
   --iou-thres 0.65 \
   --conf-thres 0.35 \
   --include onnx_end2end
```


## Running NVIDIA Triton Inference Server Container with Docker

### Usage

``` bash
bash ./start-container-triton-server.sh
```

Run this script to start the Triton Inference Server container.

Note: This script must be executed on the host operating system.

### Prerequisites

- NVIDIA Docker must be installed.
- NVIDIA GPU(s) should be available.


## Deploying TensorRT Engine and Starting Triton-Server 


### Usage Script (start-triton-server.sh) :

``` bash
Usage:
 ./start-triton-server.sh <max_batch_size> <opt_batch_size> <instance_group> [--force]
 - max_batch_size: Maximum batch size for TensorRT engines.
 - opt_batch_size: Optimal batch size for TensorRT engines.
 - instance_group: Number of TensorRT engine instances loaded per model in the Triton Server.
 - Use the flag --force to rebuild TensorRT engines even if they already exist.
```

The `--force` flag must be utilized whenever the maximum batch size of the model is smaller than the current configuration.

Example
``` bash
bash ./start-triton-server.sh  16 8 3 --force
```
This script converts ONNX models to TensorRT engines and starts the NVIDIA Triton Inference Server.

Note: This script is intended to be executed from within the Docker Triton container.

### Script Flow:
1. Checks for the existence of YOLOv7/YOLOv9 ONNX model files.
2. Downloads ONNX models if they do not exist.
2. Converts YOLOv7/YOLOv9 ONNX model to TensorRT engine with FP16 precision.
4. Updates the batch size configurations in the Triton Server config files.
5. Starts Triton Inference Server with the converted models.

<br>After running script, you can verify the availability of the model by checking this output::
``` bash
+----------+---------+--------+
| Model    | Version | Status |
+----------+---------+--------+
| yolov7   | 1       | READY  |
| yolov9-c | 1       | READY  |
| yolov9-e | 1       | READY  |
+----------+---------+--------+
```

## Model Configuration

``` bash 
models_config/
├── yolov7
│   └── config.pbtxt
├── yolov9-c
│   └── config.pbtxt
└── yolov9-e
    └── config.pbtxt

```


See [Triton Model Configuration Documentation](https://github.com/triton-inference-server/server/blob/main/docs/model_configuration.md#model-configuration) for more info.


Example of Yolo Configuration <br>

Note:<br>
* The values of 100 in the det_boxes/det_scores/det_classes arrays represent the topk-all.<br>
* The setting "max_queue_delay_microseconds: 30000" is optimized for a 30fps input rate.

```
name: "yolov9"
platform: "tensorrt_plan"
max_batch_size: 8
input [
  {
    name: "images"
    data_type: TYPE_FP32
    dims: [ 3, 640, 640 ]
  }
]
output [
  {
    name: "num_dets"
    data_type: TYPE_INT32
    dims: [ 1 ]
  },
  {
    name: "det_boxes"
    data_type: TYPE_FP32
    dims: [ 100, 4 ]
  },
  {
    name: "det_scores"
    data_type: TYPE_FP32
    dims: [ 100 ]
  },
  {
    name: "det_classes"
    data_type: TYPE_INT32
    dims: [ 100 ]
  }
]
instance_group [
    {
      count: 4
      kind: KIND_GPU
      gpus: [ 0 ]
    }
]
version_policy: { latest: { num_versions: 1}}
dynamic_batching {
  max_queue_delay_microseconds: 3000
}

```
 
 

## Running Performance with Model Analyzer

See [Triton Model Analyzer Documentation](https://github.com/triton-inference-server/server/blob/main/docs/model_analyzer.md#model-analyzer) for more info.

example:


```bash
docker run -it --ipc=host --net=host nvcr.io/nvidia/tritonserver:23.08-py3-sdk /bin/bash

$ ./install/bin/perf_analyzer -m yolov9-e  \
    -u 127.0.0.1:8001 \
    -i grpc \
    --shared-memory system \
    --concurrency-range 1

*** Measurement Settings ***
  Batch size: 1
  Service Kind: Triton
  Using "time_windows" mode for stabilization
  Measurement window: 5000 msec
  Using synchronous calls for inference
  Stabilizing using average latency

Request concurrency: 1
  Client: 
    Request count: 4780
    Throughput: 265.541 infer/sec
    Avg latency: 3764 usec (standard deviation 88 usec)
    p50 latency: 3746 usec
    p90 latency: 3834 usec
    p95 latency: 3864 usec
    p99 latency: 4099 usec
    Avg gRPC time: 3758 usec ((un)marshal request/response 4 usec + response wait 3754 usec)
  Server: 
    Inference count: 4781
    Execution count: 4781
    Successful request count: 4781
    Avg request latency: 3648 usec (overhead 28 usec + queue 20 usec + compute input 1055 usec + compute infer 2510 usec + compute output 34 usec)

Inferences/Second vs. Client Average Batch Latency
Concurrency: 1, throughput: 265.541 infer/sec, latency 3764 usec

```


