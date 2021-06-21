#!/bin/ bash

DATA="data/phenotype/derived_baseline.tsv"
NEW_DATA="data/phenotype_plink2_format.txt"
BRIDGE_FILE="data/bridge_file/bridge_ukb9922_ukb58356.txt"

awk -v OFS='\t' 'BEGIN {print "FID", "IID", "apv", "sex", "age"} \
     NR == FNR && NR > 1 {a[$3]=$1; next} \
     FNR > 1 && ($1 in a) {print a[$1], a[$1], $29, $2, $3}
' $BRIDGE_FILE $DATA > $NEW_DATA
