#!/bin/bash
#SBATCH --job-name=kallisto_paired.sh                      # Job name
#SBATCH --partition=batch                           # Partition name (batch, highmem, or gpu)
#SBATCH --ntasks=1                                  # 1 task (process) for below commands
#SBATCH --cpus-per-task=4                           # CPU core count per task, by default 1
#SBATCH --mem=8G                                    # Memory per node (24GB); by default using M as unit
#SBATCH --time=1:00:00                              # Time limit hrs:mins:secs or days-hrs:mins:secs
#SBATCH --array=1-121%30
#SBATCH --output=/work/gene8940/bgf57696/rpx-rnaseq/kallisto_quant/outlogs/%x_%j.out  # Standard output log, e.g., testBowtie2_12345.out
#SBATCH --mail-user=bgf57696@uga.edu                # Where to send mail
#SBATCH --mail-type=ALL                        # Mail events (BEGIN, END, FAIL, ALL)

#set variables
OUTDIR=/work/gene8940/bgf57696/rpx-rnaseq/kallisto_quant/
LIST=/work/gene8940/bgf57696/rpx-rnaseq/kallisto_quant/fastq_paired.txt
INDEX=/work/gene8940/bgf57696/rpx-rnaseq/kallisto_quant/atlantic_cdna.idx

LINE1=$(( (SLURM_ARRAY_TASK_ID - 1) * 2 + 1))
LINE2=$(( LINE1 + 1))

R1=$(sed -n "${LINE1}p" $LIST)
R2=$(sed -n "${LINE2}p" $LIST)

SAMPLE=$(basename $R1 _1.fastq.gz)

#load kallisto module
ml kallisto/0.51.1-gompi-2023b

#quantify read transcript abundances
kallisto quant -i $INDEX -o $OUTDIR/${SAMPLE}_kallisto -t 4 -b 100 $R1 $R2

