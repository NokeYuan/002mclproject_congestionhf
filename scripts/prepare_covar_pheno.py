import pandas as pd

COVARFILE_ORI = "/lustre/scratch/scratch/rmhiaah/Projects/ukb_gwas/data/phenotype/covariates/regenie.app9922_eur.tsv"
PHENOFILE = "data/phenotype/derived_baseline.tsv"
BRIDGE_FILE = "data/bridge_file/bridge_ukb9922_ukb58356.txt"

# PREPARE COVARIATES FILE (add age column to original covariates file)
COVARFILE_NEW = "data/covariates.txt"

df_covar_ori = pd.read_table(COVARFILE_ORI)
df_bridge = pd.read_table(BRIDGE_FILE, delimiter=' ')
df_pheno = pd.read_table(PHENOFILE)

df_bridge_pheno = pd.merge(df_bridge[['ID9922_1', 'ID58356_1']], df_pheno[['eid', 'age']],
                           left_on='ID58356_1', right_on='eid')

df_covar_new = pd.merge(df_bridge_pheno, df_covar_ori, left_on = 'ID9922_1', right_on='IID')

df_covar_new['#FID'] = df_covar_new['ID9922_1']
df_covar_new['IID'] = df_covar_new['ID9922_1']
cols = ['#FID', 'IID', 'sex', 'age', 'array'] + [f'PC{x}' for x in range(1,11)]

df_covar_new[cols].to_csv(COVARFILE_NEW, sep='\t', index=False, na_rep='NA')

# PREPARE PHENOTYPE FILE (change id from app 58356 to app 9922)
PHENOFILE_9922 = "data/PVS_9922.tsv"
df_pheno_pvs_58356 = pd.read_table('data/PVS.txt')

df_pheno_pvs_9922 = pd.merge(df_pheno_pvs_58356, df_bridge[['ID9922_1', 'ID58356_1']],
                             left_on='eid', right_on='ID58356_1')

df_pheno_pvs_9922.rename(columns={'ID9922_1': '#FID', 'apv_noke': 'apv', 'ipv_noke': 'ipv' }, inplace=True)
df_pheno_pvs_9922['IID'] = df_pheno_pvs_9922['#FID']

pheno_cols = ['#FID', 'IID', 'apv', 'ipv', 'PVS']

df_pheno_pvs_9922[pheno_cols].to_csv(PHENOFILE_9922, sep='\t', index=False, na_rep='NA')
