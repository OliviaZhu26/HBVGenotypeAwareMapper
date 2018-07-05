#!/bin/bash

##qsub -pe OpenMP 8 -l mem_free=128G,h_rt=72:00:00 -cwd -V -b y bash map.sh GenotypeB.fasta filler filler AHB079

#qsub -pe OpenMP 8 -l mem_free=16G,h_rt=16:00:00 -cwd -V -b y bash HBV_genotype_mapper.sh GenotypeB_non-ambiguous.fasta filler filler AHB170_B

REF="/mnt/projects/zhuy/ecoli_pop_gen/00_All_references/HBV_Reference_non-ambiguous/"

#GenotypeB_non-ambiguous.fasta
#GenotypeC.fasta

##this options takes too long to sort, not worth the time
#bwa mem /mnt/projects/zhuy/ecoli_pop_gen/00_All_references/hg19/hg19.fasta $1 $2 | samtools view -bS - | samtools sort -n - $3.sorted

set -e
ref=$REF$1

echo 'bwa mem -M '$ref $2 $3' | samtools view -bS - > '$4'.bam'
bwa mem -M $ref $2 $3 | samtools view -bS - > $4.bam
#bwa mem -M $ref $1*R1*fastq.gz $1*R2*fastq.gz | samtools view -bS - > $1.bam
java -Djava.io.tmpdir=tmp -Xmx16g -jar /mnt/software/bin/SortSam.jar INPUT=$4.bam OUTPUT=$4.sorted.bam SORT_ORDER=coordinate
java -Djava.io.tmpdir=tmp -Xmx16g -jar /mnt/software/bin/AddOrReplaceReadGroups.jar INPUT=$4.sorted.bam OUTPUT=$4.sorted.grouped.bam RGID=$4 RGLB=$4 RGPL=Illumina RGPU=u5 RGSM=$4
samtools index $4.sorted.grouped.bam
rm $4.bam
rm $4.sorted.bam
java -Djava.io.tmpdir=tmp -Xmx16g -jar /mnt/software/bin/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $ref -I $4.sorted.grouped.bam -o $4.sorted.grouped.intervals
java -Djava.io.tmpdir=tmp -Xmx16g -jar /mnt/software/bin/GenomeAnalysisTK.jar -T IndelRealigner -R $ref -I $4.sorted.grouped.bam -targetIntervals $4.sorted.grouped.intervals -o $4.sorted.grouped.realign.bam
rm $4.sorted.grouped.bam
rm $4.sorted.grouped.bam.bai
rm $4.sorted.grouped.intervals
java -Djava.io.tmpdir=tmp -Xmx16g -jar /mnt/software/bin/GenomeAnalysisTK.jar -T DepthOfCoverage -R $ref -o $4.sorted.grouped.realign.coverage -I $4.sorted.grouped.realign.bam
rm $4.sorted.grouped.realign.coverage.sample_cumulative_coverage_counts
rm $4.sorted.grouped.realign.coverage.sample_cumulative_coverage_proportions
rm $4.sorted.grouped.realign.coverage.sample_interval_statistics
rm $4.sorted.grouped.realign.coverage.sample_interval_summary
rm $4.sorted.grouped.realign.coverage.sample_statistics
java -Djava.io.tmpdir=tmp -Xmx16g -jar /mnt/software/bin/GenomeAnalysisTK.jar -T UnifiedGenotyper -R $ref -I $4.sorted.grouped.realign.bam -o $4.sorted.grouped.realign.raw.vcf
java -Djava.io.tmpdir=tmp -Xmx16g -jar /mnt/software/bin/GenomeAnalysisTK.jar -T BaseRecalibrator -R $ref -I $4.sorted.grouped.realign.bam -knownSites $4.sorted.grouped.realign.raw.vcf -o $4.sorted.grouped.realign.recal.table
java -Djava.io.tmpdir=tmp -Xmx16g -jar /mnt/software/bin/GenomeAnalysisTK.jar -T PrintReads -R $ref -I $4.sorted.grouped.realign.bam -BQSR $4.sorted.grouped.realign.recal.table -o $4.sorted.grouped.realign.recal.bam
rm $4.sorted.grouped.realign.bam
rm $4.sorted.grouped.realign.bai
rm $4.sorted.grouped.realign.recal.table
rm $4.sorted.grouped.realign.raw.vcf
rm $4.sorted.grouped.realign.raw.vcf.idx
#java -Djava.io.tmpdir=tmp -Xmx8g -jar /mnt/software/bin/GenomeAnalysisTK.jar -T UnifiedGenotyper -R $ref -I $4.sorted.grouped.realign.recal.bam -o $4.sorted.grouped.realign.recal.vcf
/mnt/software/bin/lofreq call -d 2500 -f $ref -o $4.sorted.grouped.realign.recal.lofreq.vcf $4.sorted.grouped.realign.recal.bam
cp /home/zhuy/bin/HBV_genotype_coverage* ./
perl HBV_genotype_coverage.pl $4 ./
