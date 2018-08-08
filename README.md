# HBVGenotypeAwareMapper

<strong>HBVGenotypeAwareMapper 1.0</strong>

This wrapper script identifies best match genotype for a paired end sequencing HBV sample using a subsample of reads, maps all reads to best match genotype reference, outputs mapped .bam .coverage .vcf, and generates a log10 coverage plot with SNP frequency.  


<strong>How to Run</strong>

Place all paired fastq files within the same folder. Script will loop through all samples. 
Type from within data folder
HBVmap.sh   match   [PATHtoReferences]   Genotype8.fasta   25000   map

<strong>Prerequisites</strong>

<p>This pipeline calls on:</p>
<ul>
<li>Perl</li>
<li>bwa</li>
<li>samtools</li>
<li>GATK</li>
<li>LoFreq</li>
<li>R</li>
</ul>

<strong>Accompanying Scripts</strong>

<p>The wrapper script calls upon the following scripts:</p>
<p>Make sure they are callable directly (or copy them to working folder)</p>
<ul>
<li>HBV_genotype_caller.pl</li>
<li>HBV_genotype_mapper.pl</li> 
<li>HBV_genotype_mapper.sh</li>
<li>HBV_genotype_coverage.R</li> 
<li>HBV_genotype_coverage.pl</li> 
<li>HBV_genotype_identifier.sh</li> 
</ul>

<strong>Requires</strong>
<p>Reference files provided as HBVmap_References.zip</p>

<strong>License</strong>

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
