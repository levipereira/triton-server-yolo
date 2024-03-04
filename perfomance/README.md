# Perfomance Test using GPU RTX 4090 on AMD Ryzen 7 3700X 8-Core/ 16GB RAM

# Model Performance Evaluation using TensorRT engine 
All models were sourced from the original repository and subsequently converted to ONNX format with dynamic batching enabled. Profiling was conducted using TensorRT Engine Explorer (TREx).

All models were converted (re-parameterized) and optimized for inference.

Detailed reports will be made available in the coming days, providing comprehensive insights into the performance metrics and optimizations achieved.

**TensorRT version: 8.6.1**

### Device Properties:
- Selected Device: NVIDIA GeForce RTX 4090
- Compute Capability: 8.9
- SMs: 128.0
- Compute Clock Rate: 2.58 GHz
- Device Global Memory: 24208 MiB
- Shared Memory per SM: 100 KiB
- Memory Bus Width: 384.0 bits
- Memory Clock Rate: 10.501 GHz


# YOLO v8 vs v9 Series Models Performance Results

- **Average time**: Represents the total sum of layer latencies when profiling layers individually.
- **Latency**: Refers to the minimum, maximum, mean, median, and 99th percentile of the engine latency measurements, captured without profiling layers.
- **Throughput**: Measured in inferences per second (IPS).



# Performance Summary Tables

## Throughput and Average Time

| Model Name | Throughput (IPS) | Average Time (ms) |
|------------|------------------|-------------------|
| YOLOv7     | 978              | 1.441             |
| YOLOv7x    | 609              | 2.065             |
| YOLOv9-c   | 798              | 2.049             |
| YOLOv9-e   | 353              | 4.261             |

## Latency Summary

| Model Name | Min Latency (ms) | Max Latency (ms) | Mean Latency (ms) | Median Latency (ms) | 99th Percentile Latency (ms) |
|------------|-------------------|-------------------|-------------------|----------------------|------------------------------|
| YOLOv7     | 1.012             | 1.104             | 1.020             | 1.018                | 1.024                        |
| YOLOv7x    | 1.613             | 1.751             | 1.640             | 1.636                | 1.664                        |
| YOLOv9-c   | 1.246             | 1.359             | 1.251             | 1.250                | 1.251                        |
| YOLOv9-e   | 2.807             | 3.032             | 2.823             | 2.814                | 2.817                        |

# Performance Summary Report

## YOLOv7

### Model:
- Inputs: images: [1, 3, 640, 640]xFP32 NCHW
- Outputs: 
    - 546: [1, 3, 20, 20, 85]xFP32 NCHW
    - output: [1, 3, 80, 80, 85]xFP32 NCHW
    - 528: [1, 3, 40, 40, 85]xFP32 NCHW
- Average time: 1.441 ms
- Layers: 140
- Weights: 70.3 MB
- Activations: 558.7 MB

### Performance Summary:
- Throughput: 978.521 IPS
- Latency (ms): 
    - Min: 1.01273
    - Max: 1.10387
    - Mean: 1.02031
    - Median: 1.01782
    - 99th Percentile: 1.02405

## YOLOv7x

### Model:
- Inputs: images: [1, 3, 640, 640]xFP32 NCHW
- Outputs: 
    - 608: [1, 3, 40, 40, 85]xFP32 NCHW
    - 626: [1, 3, 20, 20, 85]xFP32 NCHW
    - output: [1, 3, 80, 80, 85]xFP32 NCHW
- Average time: 2.065 ms
- Layers: 140
- Weights: 136.0 MB
- Activations: 685.8 MB

### Performance Summary:
- Throughput: 609.044 IPS
- Latency (ms): 
    - Min: 1.61279
    - Max: 1.75104
    - Mean: 1.64025
    - Median: 1.63647
    - 99th Percentile: 1.66394

## YOLOv9-c

### Model:
- Inputs: images: [1, 3, 640, 640]xFP32 NCHW
- Outputs: output0: [1, 80, 8400]xFP32 NCHW
- Average time: 2.049 ms
- Layers: 271
- Weights: 48.2 MB
- Activations: 611.7 MB

### Performance Summary:
- Throughput: 798.327 IPS
- Latency (ms): 
    - Min: 1.24622
    - Max: 1.35886
    - Mean: 1.25097
    - Median: 1.25024
    - 99th Percentile: 1.25122

## YOLOv9-e

### Model:
- Inputs: images: [1, 3, 640, 640]xFP32 NCHW
- Outputs: output0: [1, 80, 8400]xFP32 NCHW
- Average time: 4.261 ms
- Layers: 486
- Weights: 109.3 MB
- Activations: 1706.5 MB


### Performance Summary:
- Throughput: 353.998 IPS
- Latency (ms): 
    - Min: 2.80679
    - Max: 3.03207
    - Mean: 2.8232
    - Median: 2.81396
    - 99th Percentile: 2.81689

