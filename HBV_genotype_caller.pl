use warnings;
use strict;

##Author: ZHU O. Yuan
##Script name: HBV_genotype_caller.pl
##Hepatitis B genotype identifier script II called upon by HBVmap.sh
##Usage: perl genotype_caller.pl genotype_identifier.verbose.txt 25000 > genotype_caller.out

#initiate variables
my$file=""; #fastq file being reported on
my@references=(); #array of references tested
my@counts=(); #array of read counts mapped to each reference
my$unmapped=0; #no. unmapped reads
my$lin=$ARGV[1]/4; #total number of reads sampled

sub sumarray { #sums counts in an array of numbers
    my$sum=0;
    my@array=@{$_[0]};
    for(my$a=0;$a<@array;$a++){$sum=$sum+$array[$a];}
    return $sum;
}

sub callgenotype { #prints a single line for each sample with best match genotype info
    my$total= sumarray(\@counts) + $unmapped;
    my$mapped= sumarray(\@counts);
    my$percentmapped=$mapped/$total;
    my$maxGeno=pop(@counts);
    my$percentGeno=$maxGeno/$mapped;
    print "$file\t$references[-1]\t$maxGeno\t$percentGeno\t$percentmapped\t$lin\n";
}

#prints out number and % reads mapped to each Genotype (or not)
print "ID\tGenotype\tSupportReads\t%MappedSupport\t%Mapped\tLinesUsed\n";
open (SAM, "$ARGV[0]") or die;
while (my $line = <SAM>) {
    chomp $line;
    my@data=split('\t',$line);
    if (defined $data[1]) {
	if($data[1] eq "*"){$unmapped=$data[0];} #records unmapped reads
	else{push(@counts,$data[0]);push(@references,$data[1]);} #records mapped reads and Genotype
    }
    else{
	if(defined $references[1]){ #at the start of summary stats for every new sample
	    callgenotype(); #call best match genotype for previous sample
	    $file="";@references=();@counts=();$unmapped=0; #reset all variables
	}
	$file=substr($line,2,100); #removes ./ from sample file name
    }
}close (SAM);
callgenotype();
