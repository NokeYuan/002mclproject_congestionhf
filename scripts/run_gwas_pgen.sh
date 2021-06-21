#!/bin/bash -l
#$ -S /bin/bash
#$ -N GWAS_UKB_PGEN
#$ -l mem=4G
#$ -l h_rt=24:00:00
#$ -t 1-22
#$ -pe smp 8
#$ -cwd
#$ -V
#$ -e job_logs
#$ -o job_logs

# BFILE="data/eur/C${SGE_TASK_ID}_ukbb_v3_eur_indiv_variant_qc"
PFILE="data/pgen_chr/GWAS_chr${SGE_TASK_ID}-temporary"
PHENOFILE="data/PVS_9922.tsv"
COVARFILE="data/covariates.txt"
OUTFILE="results/chr/GWAS_chr${SGE_TASK_ID}"
GENOTYPE_FOLDER="data/eur/"

plink2 \
   --pfile ${PFILE} \
   --maf 0.01 \
   --geno 0.015 \
   --covar "$COVARFILE" \
   --covar-name sex age array PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 \
   --pheno "$PHENOFILE" \
   --pheno-name PVS \
   --out $OUTFILE \
   --memory 24000 \
   --threads $NSLOTS \
   --glm cols=+a1freq,+machr2,-test hide-covar
