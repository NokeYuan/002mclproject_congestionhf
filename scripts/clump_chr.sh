#!/bin/bash

# Scripts to run clumping per chromosome
# Directory for reference LD
REF_DIR="/lustre/scratch/scratch/rmhiaah/UKB10K_ref_panel"
OUTDIR="results/chr_clump"
mkdir -p $OUTDIR

clump() {
  CHR="$1"
  TRAIT="$2"
  SUFFIX="$3"
  INFILE="results/chr/GWAS_chr${CHR}.${TRAIT}.${SUFFIX}"
  plink \
    --bfile ${REF_DIR}/C${CHR}_UKBrandom10K_v3_eur_indiv_var_qc_nodupvar \
    --clump ${INFILE} \
    --clump-field P \
    --clump-snp-field ID \
    --clump-p1 5e-8 \
    --clump-r2 0.01 \
    --clump-p2 0.01 \
    --clump-kb 5000 \
    --out ${OUTDIR}/GWAS_chr${CHR}_${TRAIT}
}

export REF_DIR OUTDIR
export -f clump

parallel "clump {} PVS glm.linear" ::: {1..22}
