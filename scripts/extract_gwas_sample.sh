#!/bin/bash

SAMPLE_FILE="data/eur/C22_ukbb_v3_eur_indiv_variant_qc.sample"
BRIDGE_FILE="data/bridge_file/bridge_ukb9922_ukb58356.txt"
OUTFILE="data/gwas_sample_app9922_app58356.tsv"

awk -v OFS="\t" \
  'BEGIN {print "eid_9922", "eid_58356"}
   NR == FNR && NR > 2 {a[$1]; next}
   $1 in a {print $1, $3}' $SAMPLE_FILE $BRIDGE_FILE > $OUTFILE
