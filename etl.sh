#!/bin/bash

printf "1\n32\n64\n128\n256" >> ./workspace/logs/processed/batches.log
paste -d "," ./workspace/logs/processed/batches.log \
             ./workspace/logs/processed/tf_non_mkl_resnet20.log \
             ./workspace/logs/processed/nchw_tf_mkl_resnet20.log \
             ./workspace/logs/processed/tf_mkl_resnet20.log | tr -d "[:blank:]" > ./workspace/logs/processed/tf_final.log
sed -i 1i"batch,non_mkl,nchw_mkl,nhwc_mkl" ./workspace/logs/processed/tf_final.log
rm ./workspace/logs/processed/batches.log
mkdir -p ./workspace/plots/
echo "Final data looks like::"
cat ./workspace/logs/processed/tf_final.log



