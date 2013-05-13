#! /usr/bin/env Rscript

library(HadoopStreaming)
library(getopt)

doStuff <- function(chunk.of.text){
  words <- strsplit(chunk.of.text, " ")
  print(length(words))
}


(function() {
  input <- file("stdin", open="r")
  
  hsLineReader(file = input, chunkSize = 3, skip = 0, FUN = doStuff)
  
})()
