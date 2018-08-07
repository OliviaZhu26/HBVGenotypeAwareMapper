#!/bin/bash

##Author: ZHU O. Yuan
##Script name: HBVmap.sh
##Hepatitis B mapper wrapper script
##Usage: mapHBV.sh match $PATH/ref.fa 25000 map
##Calls: bwa lofreq R
##Requires: HBV_Genotype8.fa (contains all 8 HBV genotypes, prepare for use as reference prior to running this script)

initial_wd=`pwd`

if [[ $# -eq 0 ]] ; #print help message to screen if no options were provided
then
    echo 'Usage: mapHBV.sh match REF LINES map'
    echo 'match :Identify best match genotype if genotype_caller.out file is not already present. type anything ele to skip this'
    echo 'map :Map files according to best match genome as identified. use anything else to skip' 
    echo 'Running script from '$initial_wd
    echo 'Make sure you are running this from the fastq directory with paired fastq files'
    echo 'Can be run on multiple samples in the same folder'
    exit 0
else
    if [[ $1 = 'match' ]]; #if option 'match' given, launch genotype calling scripts
    then
	echo 'Identifying best match genotypes'	
	HBV_genotype_identifier.sh $2 $3 #script to report estimated %identity to each of 8 genotypes provided
	perl HBV_genotype_caller.pl genotype_identifier.verbose.txt $3 > genotype_caller.out #identifies closest genotype
    else
	echo 'Best match genotype calling skipped'
    fi
    if [[ $4 = 'map' ]];
    then
	echo 'Mapping to best match genotypes'
	perl HBV_genotype_mapper.pl genotype_caller.out #maps sample to best match reference
    fi
fi
