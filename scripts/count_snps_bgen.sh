#!/bin/bash

# command to count number of actual SNPs in the source BGEN files
find data/eur/ -type f -name "*bgen" | \
  parallel  "qctool_v2.0.7 -g {}" |& \
    grep ".*snps.*data/eur" | \
      awk 'BEGIN {OFS="\t"; print "N_var", "file"} \
           {gsub("\"","",$4); print $2, $4}' > results/N_variants.txt
