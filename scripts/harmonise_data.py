import pandas as pd

# read file
files = {'ins': 'results/PVS_instrument.txt',
         'gwas_x': 'results/GWAS_chr_concat.PVS.glm.linear',
         'gwas_y': 'data/GWAS/HF_HERMES.CLEAN.tsv.gz'}

ins = pd.read_table(files['ins'], header=None, squeeze=True)
df_gwas_x = pd.read_table(files['gwas_x'])
df_gwas_y = pd.read_table(files['gwas_y'])

# subset instruments & merge exposure - outcome data
df_mr = pd.merge(df_gwas_x[df_gwas_x.ID.isin(ins)],
                 df_gwas_y[df_gwas_y.varID.isin(ins)],
                 left_on='ID', right_on='varID')

# Harmonise alleles
df_mr['beta_x'] = df_mr.apply(
    lambda df: df.BETA if df.A1_x == df.A1_y else -df.BETA, axis=1)

col_rename = {'CHROM': 'chr',
              'POS': 'pos_b37',
              'ID': 'rsID',
              'SE': 'se_x',
              'beta': 'beta_y',
              'se': 'se_y'}
df_mr.rename(columns = col_rename, inplace=True)

cols = ['chr', 'pos_b37', 'rsID', 'beta_x', 'se_x', 'P_x', 'beta_y', 'se_y', 'P_y']

# write data
outfile = 'results/DATA-MR_PVS_HF.tsv'
df_mr[cols].to_csv(outfile, sep='\t', index=False)
