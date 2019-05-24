#! /usr/bin/bash

echo "creating a conda env with non mkl TensorFlow"
conda env create --file=./no_mkl_environment.yml -q &&\
  conda activate tf-no_mkl
# run benchmark and save data
./bench_tf.sh
conda deactivate &&\
  conda env remove tf-no_mkl
echo "collected data for non mkl version"
echo "creating a conda env with mkl based TensorFlow"
conda env create --file=./mkl_environment.yml -q &&\
  conda activate tf-mkl
# run benchmark and save data
./bench_tf.sh
conda deactivate &&\
  conda env remove tf-mkl
echo "collected data for mkl version"
# run benchmark and save data
./bench_tf.sh
# minimal etl
./etl.sh
# plot the data if Rscript is available
if test -f which Rscript;
  ./plot.r
fi
