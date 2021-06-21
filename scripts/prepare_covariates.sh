#/bin/bash

COVARFILE_ORI="/lustre/scratch/scratch/rmhiaah/Projects/ukb_gwas/data/phenotype/covariates/regenie.app9922_eur.tsv"
PHENOFILE="data/phenotype/derived_baseline.tsv"
BRIDGE_FILE="data/bridge_file/bridge_ukb9922_ukb58356.txt"

COVARFILE_NEW="data/covariates.txt"

awk -v OFS='\t' 'NR == FNR && NR > 1 {a[$3]=$1; next} \
     FNR > 1 && ($1 in a) {print a[$1], $3}
' $BRIDGE_FILE $PHENOFILE | \
awk -v OFS='\t' 'BEGIN {print "#IID", "sex", "age", "PC1", "PC"}'
