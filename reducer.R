#! /usr/bin/env Rscript

library(HadoopStreaming)
library(getopt)

process <- function(piece.of.map){
  #aggregate the values per word
  result <- aggregate(x=piece.of.map$value, by=list(word=piece.of.map$word), FUN=function(map.values){
    sum(as.integer(map.values))
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
