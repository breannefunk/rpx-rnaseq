#!/bin/bash
#SBATCH --job-name=sra_array.sh                      # Job name
#SBATCH --partition=batch                           # Partition name (batch, highmem, or gpu)
#SBATCH --ntasks=1                                  # 1 task (process) for below commands
#SBATCH --cpus-per-task=6                           # CPU core count per task, by default 1
#SBATCH --mem=24G                                    # Memory per node (24GB); by default using M as unit
#SBATCH --time=4:00:00                              # Time limit hrs:mins:secs or days-hrs:mins:secs
#SBATCH --array=1-150%10
#SBATCH --output=/work/gene8940/bgf57696/rpx-rnaseq/sra_fasterq/%x_%j.out  # Standard output log, e.g., testBowtie2_12345.out
#SBATCH --mail-user=bgf57696@uga.edu                # Where to send mail
#SBATCH --mail-type=ALL                        # Mail events (BEGIN, END, FAIL, ALL)

OUTDIR=/work/gene8940/bgf57696/rpx-rnaseq/sra_fasterq/
cd $OUTDIR

#load SRA Toolkit
ml SRA-Toolkit/3.2.0-gompi-2024a

#SRR IDs
SRR=$(sed -n "${SLURM_ARRAY_TASK_ID}p" sra_ids.txt)

#download NGS data for each RNASeq Run
prefetch -O $OUTDIR $SRR

#convert to FASTQ
fasterq-dump --threads 6 --progress --split-files -O $OUTDIR $SRR

#compress FASTQ files
pigz -p 6 ${SRR}*.fastq



