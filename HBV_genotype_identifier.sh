#!/bin/bash

##Author: ZHU O. Yuan
##Script name: HBV_genotype_identifier.sh
##Hepatitis B genotype identifier script called upon by HBVmap.sh
##Usage: HBV_genotype_identifier.sh $PATH_TO_REFERENCE $NUMBER_LINES
##Calls: bwa
##Outputs text summary file genotype_identifier.verbose.txt

REF=$1 #location of reference fasta
LINES=$2 #number of fastq lines to use
FILE="genotype_identifier.verbose.txt" #standard output file
#makes sure no pre-existing output file exists
if [ -f $FILE ]; then
    echo "File $FILE exists. Please verify before proceeding."
    exit 1
else
    echo "File $FILE does not exist. Proceed."
fi
#for each R1 fastq file, map 25000/4 reads to HBV_Genotype8.fa and summarize number of reads mapped to each
#25000 is arbitrary and was sufficient to identify best match genotype for 151bp reads. modify if necessary
for filename in ./*R1*fastq.gz; do
    echo $filename >> genotype_identifier.verbose.txt
    gunzip -c $filename | tail -$2 | bwa mem $REF - | awk '{print $3}' | sort | uniq -c | grep -v ':' | awk '{print $1"\t"$2}' | sort -r -k1,1n >> genotype_identifier.verbose.txt
done
