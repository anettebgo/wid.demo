#! /usr/bin/env Rscript

library(HadoopStreaming)
library(getopt)

process <- function(df){
  #aggregate the values per word
  result <- aggregate(x=df$value, by=list(word=df$word), FUN=function(d){
    sum(as.integer(d))
  })
  
  #write a nicely formatted table
  write.table(result, file=stdout(), quote=FALSE, row.names=FALSE, col.names=FALSE)
}

reduce <- function(input){
  #create column names to make is easier to work with the data set
  names <- c("word", "value")
  cols = as.list(vector(length=2, mode="character"))
  names(cols) <- names
  
  #read from the input
  hsTableReader(file=input, cols, ignoreKey=TRUE, chunkSize=100000, FUN=process, sep=" ")
}

(function() {
  input <- file("stdin", open="r")
  reduce(input)
})()
