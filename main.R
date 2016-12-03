rm(list=ls(all=TRUE))

library(readr)
library(plotly)
library(tidyverse)
library(pbapply)
library(rscopus)
library(gbm)

green.smpl.cls.dat <- read_csv('./data/sampled_green_with_region_id')

summary(green.smpl.cls.dat)
