#!/bin/bash
#SBATCH --job-name=kallisto_index.sh                      # Job name
#SBATCH --partition=batch                           # Partition name (batch, highmem, or gpu)
#SBATCH --ntasks=1                                  # 1 task (process) for below commands
#SBATCH --cpus-per-task=4                           # CPU core count per task, by default 1
#SBATCH --mem=8G                                    # Memory per node (8GB); by default using M as unit
#SBATCH --time=1:00:00                              # Time limit hrs:mins:secs or days-hrs:mins:secs
#SBATCH --output=/work/gene8940/bgf57696/rpx-rnaseq/kallisto_quant/outlogs/%x_%j.out  # Standard output log, e.g., testBowtie2_12345.out
#SBATCH --mail-user=bgf57696@uga.edu                # Where to send mail
#SBATCH --mail-type=ALL                        # Mail events (BEGIN, END, FAIL, ALL)

OUTDIR=/work/gene8940/bgf57696/rpx-rnaseq/kallisto_quant/
cd $OUTDIR

#download and unzip cdna file for index
URL=https://spuddb.uga.edu/data/ATL_v3/ATL_v3.hc_gene_models.repr.cdna.fa.gz
curl -s $URL | gunzip -c > atlantic_cdna.fa

#load kallisto module
ml kallisto/0.51.1-gompi-2023b

#generate kallisto index
kallisto index -i atlantic_cdna.idx atlantic_cdna.fa