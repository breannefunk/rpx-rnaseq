#!/bin/bash
#SBATCH --job-name=fastqc_array.sh                      # Job name
#SBATCH --partition=batch                           # Partition name (batch, highmem, or gpu)
#SBATCH --ntasks=1                                  # 1 task (process) for below commands
#SBATCH --cpus-per-task=4                           # CPU core count per task, by default 1
#SBATCH --mem=8G                                    # Memory per node (24GB); by default using M as unit
#SBATCH --time=1:00:00                              # Time limit hrs:mins:secs or days-hrs:mins:secs
#SBATCH --array=1-271%30
#SBATCH --output=/work/gene8940/bgf57696/rpx-rnaseq/fastqc_results/%x_%j.out  # Standard output log, e.g., testBowtie2_12345.out
#SBATCH --mail-user=bgf57696@uga.edu                # Where to send mail
#SBATCH --mail-type=ALL                        # Mail events (BEGIN, END, FAIL, ALL)

#set outdir & fastQC variables
OUTDIR=/work/gene8940/bgf57696/rpx-rnaseq/fastqc_results/
cd $OUTDIR

FASTQC=$(sed -n "${SLURM_ARRAY_TASK_ID}p" fastq_list.txt)

#load FastQC
ml FastQC/0.12.1-Java-11

#run FastQC
fastqc -t 4 -o "$OUTDIR" "$FASTQC"

