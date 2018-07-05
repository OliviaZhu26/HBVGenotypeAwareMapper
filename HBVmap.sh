#!/bin/bash

##qsub -pe OpenMP 8 -l mem_free=128G,h_rt=72:00:00 -cwd -V -b y
#qsub -pe OpenMP 8 -l mem_free=16G,h_rt=48:00:00 -cwd -V -b y HBVmap.sh 0 map
#qsub -pe OpenMP 8 -l mem_free=16G,h_rt=48:00:00 -cwd -V -b y HBVmap.sh match map
##remember to clear all files
initial_wd=`pwd`

if [[ $# -eq 0 ]] ;
then
    echo 'Usage: mapHBV.sh match map'
    echo 'match :Identify best match genotype if genotype_caller.out file is not already present. type anything ele to skip this'
    echo 'map :Map files according to best match genome as identified. use anything else to skip' 
    echo 'Running script from '$initial_wd
    echo 'Make sure you are running this from the fastq directory with paired fastq files'
    exit 0
else
    
    if [[ $1 = 'match' ]];
    then
	echo 'Identifying best match genotypes'	
	HBV_genotype_identifier.sh
	cp /home/zhuy/bin/HBV_genotype_caller.pl ./
	perl HBV_genotype_caller.pl genotype_identifier.verbose.txt 25000 > genotype_caller.out
    else
	echo 'Best match genotype calling skipped'
    fi
    
    if [[ $2 = 'map' ]];
    then
	echo 'Mapping to best match genotypes'
	cp /home/zhuy/bin/HBV_genotype_mapper.pl ./
	perl /home/zhuy/bin/HBV_genotype_mapper.pl genotype_caller.out
    fi
fi
