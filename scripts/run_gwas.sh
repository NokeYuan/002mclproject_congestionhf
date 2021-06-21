#!/bin/bash -l
#$ -S /bin/bash
#$ -N GWAS_UKB_PLASMA_VOLUME_3
#$ -l mem=8G
#$ -l h_rt=24:00:00
#$ -t 1-22
#$ -pe smp 8
#$ -cwd
#$ -V
#$ -e job_logs
#$ -o job_logs

BFILE="data/eur/C${SGE_TASK_ID}_ukbb_v3_eur_indiv_variant_qc"
PHENOFILE="data/phenotype_plink2_format.txt"
COVARFILE="data/covariates.txt"
OUTFILE="results/chr/GWAS_chr${SGE_TASK_ID}"
GENOTYPE_FOLDER="data/eur/"

plink2 \
   --bgen "${BFILE}.bgen" \
   --sample "${BFILE}.sample" \
   --maf 0.01 \
   --geno 0.015 \
   --covar "data/covariates.txt" \
   --covar-name sex array PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 \
   --pheno "data/phenotype_plink2_format.txt" \
   --pheno-name apv \
   --out $OUTFILE \
   --memory 8000 \
   --threads $NSLOTS \
   --glm cols=+a1freq,+machr2,-test hide-covar
