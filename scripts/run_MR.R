#!/usr/bin/env Rscript

'This is a simple wrapper of MendelianRandomization package.
(for demonstration only)

Usage:
  run_mr.R -d <data> -e <exposure> -o <outcome>
  run_mr.R -d <data> -e <exposure> -o <outcome> -s <snps>

Options:
  -h --help      Show this screen.
  -d --data      Tab-delimited file containing data of genetic association estimates
  -e --exposure  Name of exposure (Options: ldlc, hldc, tg)
  -o --outcome   Name of outcome (Option: cad)
  -s --snps      [OPTIONAL] File containing rsIDs of SNP instruments to include (one SNP per newline)
' -> doc

library(docopt)
args <- docopt(doc)
library(MendelianRandomization)
library(data.table)
library(glue)
library(ggplot2)

df <- fread(args$data)

if (!is.null(args$snps)) {
  snps <- fread(args$snps, sep = "\n", header = F)[[1]]
  df <- df[rsID %in% snps]
}

set.seed(888)

run_MR <- function(expo, outcome, method = "main", ...){
  input <- mr_input(
    bx = df[[paste0("beta_", expo)]],
    bxse = df[[paste0("se_", expo)]],
    by = df[[paste0("beta_", outcome)]],
    byse = df[[paste0("se_", outcome)]],
    exposure = toupper(expo),
    outcome = toupper(outcome),
  )
  return(mr_allmethods(input, method = method, ...))
}

X <- toupper(args$exposure)
Y <- toupper(args$outcome)
n_snps <- nrow(df)

print(
  glue(
    "
  Begin analysis ...
  Found {n_snps} SNP instruments for {X}
  Running two-sample MR analysis with exposure: {X} and outcome: {Y}
  \n
       "
  )
)

results <- run_MR(args$exposure, args$outcome)

cat("Analysis done, results:\n\n")
print(results)

# Save output & plot
if (!dir.exists("results")) dir.create("results")
if (!dir.exists("plots")) dir.create("plots")

results_file <- glue("results/MR_{X}_{Y}_{n_snps}SNPs.tsv")
fwrite(results@Values, results_file, sep = "\t")

plot <- mr_plot(results) +
labs(title = glue("Estimated effect of {X} on {Y} ({n_snps} SNP instruments)"))
plot_file <- glue("plots/MR_{X}_{Y}_{n_snps}SNPs.png")
suppressMessages(ggplot2::ggsave(plot_file, plot))

print(glue(
  "\n
Saving MR results to: {results_file}
Saving MR plot to: {plot_file}
           \n"
))
