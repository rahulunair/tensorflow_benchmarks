#!/bin/bash
BENCH_REPO="https://github.com/tensorflow/benchmarks"
BENCH_BRANCH="cnn_tf_v1.13_compatible"
BENCH_DIR=workspace

# create workspace and logs dir and clone benchmarks
mkdir -p $BENCH_DIR && cd $BENCH_DIR &&\
  mkdir -p ./logs/{processed,raw} &&\
  git clone --quiet $BENCH_REPO && cd benchmarks &&\
  git checkout $BENCH_BRANCH && cd .. 

# run the benchmarks, save logs.  
# depending upon if mkl is available or not, logs are saved in seperate location
MKL_AVL=`python <<END 
import tensorflow
print(tensorflow.pywrap_tensorflow.IsMklEnabled())
END`
echo "Is MKL available:: $MKL_AVL"

if [ "$MKL_AVL" = "True" ]; then
  FILENAME="tf_mkl_resnet20.log"
  for batch in 1 32 64 128 256; do
      echo "ResNet20 inference with batch size: $batch"
      python benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
        --device=cpu --data_format=NHWC \
        --forward_only --data_name=cifar10 \
        --model=resnet20 --batch_size=$batch --mkl | tee -a ./logs/raw/$FILENAME | tail -n 2 | head -n 1 | tr ':' $'\n' | tail -n 1 >> ./logs/processed/$FILENAME
  done
  for batch in 1 32 64 128 256; do
      echo "ResNet20 inference with batch size: $batch"
      python benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
        --device=cpu --data_format=NHWC \
        --forward_only --data_name=cifar10 \
        --model=resnet20 --batch_size=$batch --mkl --data_format=NCHW | tee -a ./logs/raw/nchw_$FILENAME | tail -n 2 | head -n 1 | tr ':' $'\n' | tail -n 1 >> ./logs/processed/nchw_$FILENAME
  done
else
  FILENAME="tf_non_mkl_resnet20.log"
  for batch in 1 32 64 128 256; do
    echo "ResNet20 inference with batch size: $batch"
    python benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
      --device=cpu --data_format=NHWC \
      --forward_only --data_name=cifar10 \
      --model=resnet20 --batch_size=$batch | tee -a ./logs/raw/$FILENAME | tail -n 2 | head -n 1 | tr ':' $'\n' | tail -n 1 >> ./logs/processed/$FILENAME
  done
fi
echo "Log saved to:: $FILENAME"
