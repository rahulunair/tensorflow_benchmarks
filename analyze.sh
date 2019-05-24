#!/bin/bash

printf "1\n32\n64\n128\n256" >> ./logs/processed/batches.log
paste -d "," .logs/processed/batches.log ./logs/processed/tf_non_mkl_resnet20.log ./logs/processed/tf_mkl_resnet20.log | tr -d "[:blank:]" > ./logs/processed/tf_final.log
sed -i 1i"batch,non_mkl,mkl" tf_final.log
rm batches.log
echo "Final data looks like::"
cat ./logs/processed/tf_final.log




