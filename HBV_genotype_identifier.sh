#!/bin/bash

REF="/mnt/projects/zhuy/ecoli_pop_gen/00_All_references/HBV_Reference_non-ambiguous/Genotype8.fasta"

FILE="genotype_identifier.verbose.txt"
if [ -f $FILE ]; then
    echo "File $FILE exists. Please verify before proceeding."
    exit 1
else
    echo "File $FILE does not exist. Proceed."
fi
#rm genotype_identifier.verbose.txt

for filename in ./*R1*fastq.gz; do
    #echo $filename >> genotype_identifier.fast.txt
    echo $filename >> genotype_identifier.verbose.txt
    #gunzip -c $filename | tail -10000 | bwa mem $REF - | awk '{print $3}' | sort | uniq -c | awk '{print $1"\t"$2}' | grep 'ref' | sort -k1,1n | tail -1 >> genotype_identifier.fast.txt
    gunzip -c $filename | tail -25000 | bwa mem $REF - | awk '{print $3}' | sort | uniq -c | grep -v ':' | awk '{print $1"\t"$2}' | sort -r -k1,1n >> genotype_identifier.verbose.txt
done

#perl HBV_genotype_caller.pl genotype_identifier.verbose.txt 25000 > genotype_caller.out
