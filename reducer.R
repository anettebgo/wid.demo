#! /usr/bin/env Rscript

library(HadoopStreaming)
library(getopt)

process <- function(df){
  result <- aggregate(x=df$value, by=list(word=df$word), FUN=function(d){
    sum(as.integer(d))
  })
  write.table(result, file=stdout(), quote=FALSE, row.names=FALSE)
}

reduce <- function(input){
  names <- c("word", "value")
  cols = as.list(vector(length=2, mode="character"))
  names(cols) <- names
  
  hsTableReader(file=input, cols, ignoreKey=TRUE, chunkSize=100000, FUN=process, sep=" ")
}

(function() {
  input <- file("stdin", open="r")
  result <- reduce(input)
})()
