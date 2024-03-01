# Perfomance Test using GPU RTX 4090 on AMD Ryzen 7 3700X 8-Core/ 16GB RAM

All tests can be reproduced by using this [repo](https://github.com/levipereira/triton-server-yolo-v7-v9)

# Model Performance Evaluation using TensorRT engine 

**TensorRT version: 8.6.1**

The YOLOv7, YOLOv9-c and YOLOv9-e models have been converted to ONNX with the Efficient NMS plugin.



## [Test 1](#result-test-1)

- **Objective:** Assess the individual performance of each model.
- **Setup:**
  - 1 instance
  - 1 concurrent client
  - Model configured with batch size 1

## [Test 2](#result-test-2)

- **Objective:** Evaluate global performance and discover the maximum potential performance of the model.
- **Setup:**
  - 4 instances of the model
  - 8 batch size per model
  - Client concurrent configuration:
    - Starting with 8 concurrent clients
    - Incrementing by 8 concurrent clients
    - Reaching a maximum of 128 concurrent clients

 ## Overall Result

The tests demonstrated that the YOLOv9-C model requires some optimizations to perform better with the TensorRT engine. It had a worse performance compared to its predecessor, YOLOv7. The next steps involve profiling the models to identify bottlenecks.



# Result Test 1

### YOLOv7

`Latency: 4ms` <br>
`Throughput: 265 infer/sec`

``` bash
p99 latency: 4099 usec

Inferences/Second vs. Client Average Batch Latency
Concurrency: 1, throughput: 265.541 infer/sec, latency 3764 usec
```
Report [report_rtx_4090_yolov7_instance_1_batch_size_1](report_rtx_4090_yolov7_instance_1_batch_size_1.txt)

### YOLOv9-C (Worst)

`Latency: 4.4ms` <br>
`Throughput: 240 infer/sec`

``` bash
p99 latency: 4401 usec

Inferences/Second vs. Client Average Batch Latency
Concurrency: 1, throughput: 240.82 infer/sec, latency 4151 usec
```
Report [report_rtx_4090_yolov9-c_instance_1_batch_size_1](report_rtx_4090_yolov9-c_instance_1_batch_size_1.txt)

### YOLOv9-E (Best)

`Latency: 3.8ms` <br>
`Throughput: 282 infer/sec`

``` bash
p99 latency: 3812 usec

Inferences/Second vs. Client Average Batch Latency
Concurrency: 1, throughput: 282.649 infer/sec, latency 3536 usec
```
Report [report_rtx_4090_yolov9-e_instance_1_batch_size_1](report_rtx_4090_yolov9-e_instance_1_batch_size_1.txt)


<br><br>
# Result Test 2


### YOLOv7
Best Result<br>
`Concurrency: 32`<br>
`Latency: 29.1ms` <br>
`Throughput: 1095 infer/sec`

``` bash
Inferences/Second vs. Client Average Batch Latency
Concurrency: 8, throughput: 481.744 infer/sec, latency 16601 usec
Concurrency: 16, throughput: 743.934 infer/sec, latency 21496 usec
Concurrency: 24, throughput: 1017.68 infer/sec, latency 23574 usec
Concurrency: 32, throughput: 1095.88 infer/sec, latency 29189 usec
Concurrency: 40, throughput: 1096.75 infer/sec, latency 36454 usec
Concurrency: 48, throughput: 1093.66 infer/sec, latency 43857 usec
Concurrency: 56, throughput: 1093.65 infer/sec, latency 51169 usec
Concurrency: 64, throughput: 1093.82 infer/sec, latency 58481 usec
Concurrency: 72, throughput: 1094.08 infer/sec, latency 65783 usec
Concurrency: 80, throughput: 1094.08 infer/sec, latency 73096 usec
Concurrency: 88, throughput: 1094.09 infer/sec, latency 80401 usec
Concurrency: 96, throughput: 1093.65 infer/sec, latency 87719 usec
Concurrency: 104, throughput: 1094.09 infer/sec, latency 95022 usec
Concurrency: 112, throughput: 1094.03 infer/sec, latency 102347 usec
Concurrency: 120, throughput: 1094.1 infer/sec, latency 109659 usec
Concurrency: 128, throughput: 1093.62 infer/sec, latency 116983 usec
```
Report [report_rtx_4090_yolov7_concurrency_8-128_instance_4_batch_size_8](report_rtx_4090_yolov7_concurrency_8-128_instance_4_batch_size_8.txt)

### YOLOv9-C (Worst)

Best Result<br>
`Concurrency: 32`<br>
`Latency: 43.9ms` <br>
`Throughput: 728 infer/sec`


``` bash
Inferences/Second vs. Client Average Batch Latency
Concurrency: 8, throughput: 385.748 infer/sec, latency 20716 usec
Concurrency: 16, throughput: 666.166 infer/sec, latency 24020 usec
Concurrency: 24, throughput: 697.258 infer/sec, latency 34405 usec
Concurrency: 32, throughput: 728.366 infer/sec, latency 43913 usec
Concurrency: 40, throughput: 728.826 infer/sec, latency 54844 usec
Concurrency: 48, throughput: 723.484 infer/sec, latency 66320 usec
Concurrency: 56, throughput: 659.06 infer/sec, latency 84793 usec
Concurrency: 64, throughput: 649.282 infer/sec, latency 98546 usec
Concurrency: 72, throughput: 648.387 infer/sec, latency 110982 usec
Concurrency: 80, throughput: 649.704 infer/sec, latency 123067 usec
Concurrency: 88, throughput: 648.383 infer/sec, latency 135658 usec
Concurrency: 96, throughput: 647.949 infer/sec, latency 147933 usec
Concurrency: 104, throughput: 647.947 infer/sec, latency 160398 usec
Concurrency: 112, throughput: 647.48 infer/sec, latency 172840 usec
Concurrency: 120, throughput: 647.157 infer/sec, latency 185295 usec
Concurrency: 128, throughput: 647.056 infer/sec, latency 197744 usec
```
Report [report_rtx_4090_yolov9-c_concurrency_8-128_instance_4_batch_size_8](report_rtx_4090_yolov9-c_concurrency_8-128_instance_4_batch_size_8.txt)

### YOLOv9-E (Best)

Best Result<br>
`Concurrency: 32`<br>
`Latency: 28.9ms` <br>
`Throughput: 1103 infer/sec`

``` bash
Inferences/Second vs. Client Average Batch Latency
Concurrency: 8, throughput: 475.967 infer/sec, latency 16803 usec
Concurrency: 16, throughput: 758.159 infer/sec, latency 21084 usec
Concurrency: 24, throughput: 976.466 infer/sec, latency 24567 usec
Concurrency: 32, throughput: 1103.89 infer/sec, latency 28987 usec
Concurrency: 40, throughput: 1095 infer/sec, latency 36509 usec
Concurrency: 48, throughput: 1093.22 infer/sec, latency 43898 usec
Concurrency: 56, throughput: 1009.19 infer/sec, latency 55453 usec
Concurrency: 64, throughput: 1011 infer/sec, latency 63265 usec
Concurrency: 72, throughput: 1013.21 infer/sec, latency 71060 usec
Concurrency: 80, throughput: 1012.78 infer/sec, latency 78944 usec
Concurrency: 88, throughput: 1011.44 infer/sec, latency 86984 usec
Concurrency: 96, throughput: 1013.24 infer/sec, latency 94708 usec
Concurrency: 104, throughput: 1012.79 infer/sec, latency 102649 usec
Concurrency: 112, throughput: 1016.33 infer/sec, latency 110149 usec
Concurrency: 120, throughput: 1019.89 infer/sec, latency 117610 usec
Concurrency: 128, throughput: 1013.22 infer/sec, latency 126297 usec
```
Report [report_rtx_4090_yolov9-e_concurrency_8-128_instance_4_batch_size_8](report_rtx_4090_yolov9-e_concurrency_8-128_instance_4_batch_size_8.txt)

 