#! /usr/bin/bash

# run benchmark and save data
./bench_tf.sh
# minimal etl
./etl.sh
# plot the data if Rscript is available
if test -f which Rscript;
  ./plot.r
fi
