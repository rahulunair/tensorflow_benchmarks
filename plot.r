require(ggplot2)
require(tidyverse)
df <- read.csv("./workspace/logs/processed/tf_final.log", header=TRUE)
tidy_df <- tidyr::gather(
  data=df,
  key="mkldnn",
  value="throughput",
  mkl,non_mkl
  )

tidy_df$batch <- factor(tidy_df$batch)
plt <- ggplot(data=tidy_df, mapping=aes(x=batch, y=throughput, fill=mkldnn)) +
       geom_bar(stat="identity", position=position_dodge()) +
       ggtitle("Inference on Intel i9-7900X CPU with model: Resnet20") +
       theme(plot.title = element_text(hjust = 0.5)) + 
       xlab("Batch Size")  + ylab("Throughput (images/sec)") +
       scale_fill_brewer(palette="Paired")
ggsave(filename="./workspace/plots/tf_mkl_non_mkl.pdf", plt, device="pdf")
