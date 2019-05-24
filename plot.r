#!/usr/bin/env Rscript

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyr, ggplot2)

df <- read.csv("./workspace/logs/processed/tf_final.log", header=TRUE)
tidy_df <- tidyr::gather(
  data=df,
  key="mkldnn",
  value="throughput",
  nhwc_mkl,nchw_mkl,non_mkl
  )

tidy_df$batch <- factor(tidy_df$batch)
tidy_df$mkldnn <- factor(tidy_df$mkldnn, levels=c("non_mkl", "nchw_mkl", "nhwc_mkl"))
plt <- ggplot(data=tidy_df, mapping=aes(x=batch, y=throughput, fill=mkldnn)) +
       geom_bar(stat="identity", position=position_dodge()) +
       ggtitle("Inference on Intel i9-7900X CPU with model: Resnet20") + 
       xlab("Batch Size")  + ylab("Throughput (images/sec)") +
       scale_fill_brewer(palette="Blues") + theme_classic() 
ggsave(filename="./workspace/plots/tf_mkl_non_mkl.pdf", plt, device="pdf")
