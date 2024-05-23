# Triton Server YOLO Models 

This repository serves as an example of deploying the YOLO models on Triton Server for performance and testing purposes. It includes support for applications developed using Nvidia DeepStream.<br>Currently, only [YOLOv7](https://github.com/WongKinYiu/yolov7), [YOLOv7 QAT](https://github.com/levipereira/yolo_deepstream/tree/main/yolov7_qat),  [YOLOv8](https://github.com/levipereira/ultralytics),  [YOLOv9](https://github.com/WongKinYiu/yolov9/) and [YOLOv9 QAT](https://github.com/levipereira/yolov9/tree/yolov9-qat) are supported.

> For YOLOv8 Models we are using custom plugin YOLO_NMS_TRT, the End2End implementation is not available on official Repo. Only on https://github.com/levipereira/ultralytics


## Triton Client Repository
For testing and evaluating YOLO models, you can utilize the repository [triton-client-yolo](https://github.com/levipereira/triton-client-yolo)


# Evaluation Test on TensorRT 
Evaluation test was perfomed using this [client](https://github.com/levipereira/triton-client-yolo?tab=readme-ov-file#evaluating-coco-dataset-on-yolo-models)

[Models Details](https://github.com/levipereira/triton-server-yolo/releases/tag/v0.0.1)
## YOLOv9
| Model ONNX > TensorRT | Test Size | AP<sup>val</sup> | AP<sub>50</sub><sup>val</sup> | AP<sub>75</sub><sup>val</sup> |
| :-- | :-: | :-: | :-: | :-: |
| [**YOLOv9-C (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov9-c-end2end.onnx) | 640 | **52.9%** | **70.1%** | **57.7%** |
| [**YOLOv9-C ReLU (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov9-c-relu-end2end.onnx) | 640 | **51.7%** | **68.8%** | **56.3%** |
| [**YOLOv9-E (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov9-e-end2end.onnx) | 640 | **55.4%** | **72.6%** | **60.3%** |
| [**YOLOv9-C QAT**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov9-c-qat-end2end.onnx) | 640 | **52.7%** | **69.8%** | **57.5%** |
| [**YOLOv9-C ReLU QAT**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov9-c-relu-qat-end2end.onnx) | 640 | **51.6%** | **69.7%** | **56.3%** |
| [**YOLOv9-E QAT**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov9-e-qat-end2end.onnx) | 640 | **55.3%** | **72.4%** | **60.2%** |

## YOLOv8
| Model ONNX > TensorRT | Test Size | AP<sup>val</sup> | AP<sub>50</sub><sup>val</sup> | AP<sub>75</sub><sup>val</sup> |
| :-- | :-: | :-: | :-: | :-: |
| [**YOLOv8n (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov8n-trt.onnx) | 640 | **37.3%** | **52.6%** | **40.5%** |
| [**YOLOv8s (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov8s-trt.onnx) | 640 | **44.9%** | **61.6%** | **48.6%** |
| [**YOLOv8m (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov8m-trt.onnx) | 640 | **50.1%** | **67%** | **54.6%** |
| [**YOLOv8l (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov8l-trt.onnx) | 640 | **52.7%** | **69.6%** | **57.4%** |
| [**YOLOv8x (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov8x-trt.onnx) | 640 | **53.7%** | **70.7%** | **58.6%** |

## YOLOv7
| Model ONNX > TensorRT | Test Size | AP<sup>val</sup> | AP<sub>50</sub><sup>val</sup> | AP<sub>75</sub><sup>val</sup> |
| :-- | :-: | :-: | :-: | :-: |
| [**YOLOv7 (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov7-end2end.onnx) | 640 | **51.1%** | **69.3%** | **55.6%** |
| [**YOLOv7x (FP16)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov7x-end2end.onnx) | 640 | **52.9%** | **70.8%** | **57.4%** |
| [**YOLOv7-QAT (INT8)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov7-qat-end2end.onnx) | 640 | **50.9%** | **69.2%** | **55.5%** |
| [**YOLOv7x-QAT (INT8)**](https://github.com/levipereira/triton-server-yolo/releases/download/v0.0.1/eval-yolov7x-qat-end2end.onnx) | 640 | **52.5%** | **70.6%** | **57.3%** |


## Description

This repository utilizes exported models using ONNX. 
It offers two types of ONNX models 

1. Model with Dynamic Shape and Dynamic Batch Size with End2End using Efficient NMS or YOLO_NMS_TRT plugin <br>
  It offers two types of configuration models: 
  - A model optimized for evaluation (`--topk-all 300 --iou-thres 0.7 --conf-thres 0.001`).
  - A model optimized for inference  (`--topk-all 100 --iou-thres 0.45 --conf-thres 0.25`).

2. Model with Dynamic Shapes and Dynamic Batching without End2End.
  - The Non-Maximum Suppression must be handled by Client  

Detailed Models can be found [here](https://github.com/levipereira/triton-server-yolo/releases/tag/v0.0.1)


## Starting NVIDIA Triton Inference Server Container with Docker

### Prerequisites

- Docker with support [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) must be installed.
- NVIDIA GPU(s) should be available.

### Usage

``` bash
git clone https://github.com/levipereira/triton-server-yolo.git
cd triton-server-yolo
# Start Docker container
bash ./start-container-triton-server.sh
```

### Install compiled `libnvinfer_plugin` with YoloNMS
  1. Download and install compiled   `libnvinfer_plugin`
      ```bash
      cd TensorRTPlugin
      ./patch_libnvinfer.sh --download
      cd ..
      ```
  2. Or build from source the  `libnvinfer_plugin` <br>
     [TensorRTPlugin](TensorRTPlugin)
     


## Starting Triton Inference Server 

Inside Docker Container use `bash ./start-triton-server.sh ` 

#### Script Usage
This script is used to build TensorRT engines and start Triton-Server for YOLO models.
```
cd /apps
bash ./start-triton-server.sh
```


## Script Options
- **--models**: Specify the YOLO model name(s). Choose one or more with comma separation. Available options: <br>
`yolov9-c`<br>
`yolov9-c-relu`<br> 
`yolov9-c-qat`<br> 
`yolov9-c-relu-qat`<br> 
`yolov9-e`<br>
`yolov9-e-qat`<br> 
`yolov8n`<br> 
`yolov8s`<br> 
`yolov8m`<br> 
`yolov8l`<br>
`yolov8x`<br> 
`yolov7`<br> 
`yolov7-qat`<br> 
`yolov7x`<br> 
`yolov7x-qat`
 - **--model_mode**: Use Model ONNX optimized for EVALUATION or INFERENCE. Choose from `'eval'` or `'infer'`.
- **--plugin**:  Options: `'efficientNMS'` or `'yoloNMS'` or `'none'`.
- **--opt_batch_size**: Specify the optimal batch size for TensorRT engines.
- **--max_batch_size**: Specify the maximum batch size for TensorRT engines.
- **--instance_group**: Specify the number of TensorRT engine instances loaded per model in the Triton Server.
- **--force**: Rebuild TensorRT engines even if they already exist.
- **--reset_all**: Purge all existing TensorRT engines and their respective configurations.


### Script Flow:
1. Checks for the existence of YOLOv7/YOLOv9 ONNX model files.
2. Downloads ONNX models if they do not exist.
2. Converts YOLOv7/YOLOv9 ONNX model to TensorRT engine with FP16 precision.
4. Updates configurations in the Triton Server config files.
5. Starts Triton Inference Server.


> **Important Note:** Building TensorRT engines for each model can take more than 15 minutes. If TensorRT engines already exist, this script reuses them.  Users can utilize the `--force` flag to trigger a fresh rebuild of the models.



#### Starting Triton Server using Models for Evaluation Purposes

example:
```bash
cd /apps
bash ./start-triton-server.sh  \
--models yolov9-c,yolov7 \
--model_mode eval \
--plugin efficientNMS \
--opt_batch_size 4 \
--max_batch_size 4 \
--instance_group 1 
```

#### Starting Triton Server using Models for Inference Purposes
example:
```bash
cd /apps
bash ./start-triton-server.sh  \
--models yolov9-c,yolov7 \
--model_mode infer \
--plugin efficientNMS \
--opt_batch_size 4 \
--max_batch_size 4 \
--instance_group 1 
``` 

#### Starting Triton Server using models for Inference Purposes without Efficient NMS.
example:
```bash
cd /apps
bash ./start-triton-server.sh  \
--models yolov9-c,yolov7 \
--model_mode infer \
--plugin none \
--opt_batch_size 4 \
--max_batch_size 4 \
--instance_group 1 
``` 

<br>After running script, you can verify the availability of the model by checking this output::
```
+----------+---------+--------+
| yolov7   | 1       | READY  |
| yolov7x  | 1       | READY  |
| yolov9-c | 1       | READY  |
| yolov9-e | 1       | READY  |
+----------+---------+--------+
```


## Manual ONNX YOLOv7/v9 exports
### Exporting YOLOv7 Series from PyTorch to ONNX With Efficient NMS plugin
This repo does not export pytorch models to ONNX. <br>
You can use the [Official Yolov7 Repository](https://github.com/WongKinYiu/yolov7)  
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

### Exporting YOLOv8 Series from PyTorch YOLOv8 to ONNX With YOLO_NMS plugin
This repo does not export pytorch models to ONNX. <br>

``` bash 
from ultralytics import YOLO
model = YOLO("yolov8n.pt") 
model.export(format="onnx_trt")
``` 

### Exporting YOLOv9 Series from PyTorch YOLOv9  to ONNX With Efficient NMS plugin
This repo does not export pytorch models to ONNX. <br>

``` bash 
python3 export.py \
   --weights ./yolov9-c.pt \
   --imgsz 640 \
   --topk-all 100 \
   --iou-thres 0.65 \
   --conf-thres 0.35 \
   --include onnx_end2end
``` 

# Additional Configurations

See [Triton Model Configuration Documentation](https://github.com/triton-inference-server/server/tree/main/docs) for more info.


Example of Yolo Configuration <br>

Note:<br>
* The values of 100 in the det_boxes/det_scores/det_classes arrays represent the topk-all.<br>
* The setting "max_queue_delay_microseconds: 30000" is optimized for a 30fps input rate.

```
name: "yolov9-c"
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

See [Triton Model Analyzer Documentation](https://github.com/triton-inference-server/model_analyzer/tree/main/docs) for more info.


On the Host Machine:

```bash
docker run -it --ipc=host --net=host nvcr.io/nvidia/tritonserver:23.08-py3-sdk /bin/bash

$ ./install/bin/perf_analyzer -m yolov7 -u 127.0.0.1:8001 -i grpc --shared-memory system --concurrency-range 1
*** Measurement Settings ***
  Batch size: 1
  Service Kind: Triton
  Using "time_windows" mode for stabilization
  Measurement window: 5000 msec
  Using synchronous calls for inference
  Stabilizing using average latency

Request concurrency: 1
  Client:
    Request count: 7524
    Throughput: 417.972 infer/sec
    Avg latency: 2391 usec (standard deviation 1235 usec)
    p50 latency: 2362 usec
    p90 latency: 2460 usec
    p95 latency: 2484 usec
    p99 latency: 2669 usec
    Avg gRPC time: 2386 usec ((un)marshal request/response 4 usec + response wait 2382 usec)
  Server:
    Inference count: 7524
    Execution count: 7524
    Successful request count: 7524
    Avg request latency: 2280 usec (overhead 30 usec + queue 18 usec + compute input 972 usec + compute infer 1223 usec + compute output 36 usec)

Inferences/Second vs. Client Average Batch Latency
Concurrency: 1, throughput: 417.972 infer/sec, latency 2391 usec

```


