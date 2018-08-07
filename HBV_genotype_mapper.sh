#!/bin/bash

##Author: ZHU O. Yuan 2017
##Script name: HBV_genotype_mapper.sh
##Hepatitis B mapper script called upon by HBV_genotype_mapper.pl
##Usage: HBV_genotype_mapper.sh $reference{$data[1]} $file1 $file2 $header $ref_path
##Requires: GATK tool kit and lofreq installed in path below (or modify if needed)
##Calls upon: HBV_genotype_coverage.pl to plot coverage/SNP summary figure 

BINPATH="/mnt/software/bin"
REF=$5
set -e
ref=$REF"/"$1

echo 'bwa mem -M '$ref $2 $3' | samtools view -bS - > '$4'.bam'
bwa mem -M $ref $2 $3 | samtools view -bS - > $4.bam
java -Djava.io.tmpdir=tmp -Xmx16g -jar $BINPATH"/"SortSam.jar INPUT=$4.bam OUTPUT=$4.sorted.bam SORT_ORDER=coordinate
java -Djava.io.tmpdir=tmp -Xmx16g -jar $BINPATH"/"AddOrReplaceReadGroups.jar INPUT=$4.sorted.bam OUTPUT=$4.sorted.grouped.bam RGID=$4 RGLB=$4 RGPL=Illumina RGPU=u5 RGSM=$4
samtools index $4.sorted.grouped.bam
rm $4.bam
rm $4.sorted.bam
java -Djava.io.tmpdir=tmp -Xmx16g -jar $BINPATH"/"GenomeAnalysisTK.jar -T RealignerTargetCreator -R $ref -I $4.sorted.grouped.bam -o $4.sorted.grouped.intervals
java -Djava.io.tmpdir=tmp -Xmx16g -jar $BINPATH"/"GenomeAnalysisTK.jar -T IndelRealigner -R $ref -I $4.sorted.grouped.bam -targetIntervals $4.sorted.grouped.intervals -o $4.sorted.grouped.realign.bam
rm $4.sorted.grouped.bam
rm $4.sorted.grouped.bam.bai
rm $4.sorted.grouped.intervals
java -Djava.io.tmpdir=tmp -Xmx16g -jar $BINPATH"/"GenomeAnalysisTK.jar -T DepthOfCoverage -R $ref -o $4.sorted.grouped.realign.coverage -I $4.sorted.grouped.realign.bam
rm $4.sorted.grouped.realign.coverage.sample_cumulative_coverage_counts
rm $4.sorted.grouped.realign.coverage.sample_cumulative_coverage_proportions
rm $4.sorted.grouped.realign.coverage.sample_interval_statistics
rm $4.sorted.grouped.realign.coverage.sample_interval_summary
rm $4.sorted.grouped.realign.coverage.sample_statistics
java -Djava.io.tmpdir=tmp -Xmx16g -jar $BINPATH"/"GenomeAnalysisTK.jar -T UnifiedGenotyper -R $ref -I $4.sorted.grouped.realign.bam -o $4.sorted.grouped.realign.raw.vcf
java -Djava.io.tmpdir=tmp -Xmx16g -jar $BINPATH"/"GenomeAnalysisTK.jar -T BaseRecalibrator -R $ref -I $4.sorted.grouped.realign.bam -knownSites $4.sorted.grouped.realign.raw.vcf -o $4.sorted.grouped.realign.recal.table
java -Djava.io.tmpdir=tmp -Xmx16g -jar $BINPATH"/"GenomeAnalysisTK.jar -T PrintReads -R $ref -I $4.sorted.grouped.realign.bam -BQSR $4.sorted.grouped.realign.recal.table -o $4.sorted.grouped.realign.recal.bam
rm $4.sorted.grouped.realign.bam
rm $4.sorted.grouped.realign.bai
rm $4.sorted.grouped.realign.recal.table
rm $4.sorted.grouped.realign.raw.vcf
rm $4.sorted.grouped.realign.raw.vcf.idx
$BINPATH"/"lofreq call -d 2500 -f $ref -o $4.sorted.grouped.realign.recal.lofreq.vcf $4.sorted.grouped.realign.recal.bam
perl HBV_genotype_coverage.pl $4 ./
