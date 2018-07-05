use warnings;
use strict;
#perl genotype_caller.pl genotype_identifier.verbose.txt 10000

#open(NOUT, '>>', $ARGV[2]);
my$file="";my@references=();my@counts=();my$unmapped=0;my$lin=$ARGV[1]/4;

sub sumarray {
    my$sum=0;
    my@array=@{$_[0]};
    for(my$a=0;$a<@array;$a++){$sum=$sum+$array[$a];}#print"$array[$a]\t$sum\n";}
    #print "$sum\n";
    return $sum;
}

sub callgenotype {
    #for(my$b=0;$b<@counts;$b++){print $counts[$b]."\n";}
    my$total= sumarray(\@counts) + $unmapped;
    my$mapped= sumarray(\@counts);
    my$percentmapped=$mapped/$total;
    my$maxGeno=pop(@counts);
    my$percentGeno=$maxGeno/$mapped;
    #print "$mapped\t$total\n";
    #if(($percentmapped > 0.5)||($maxGeno > 1000)){
	print "$file\t$references[-1]\t$maxGeno\t$percentGeno\t$percentmapped\t$lin\n";
    #}
    #else{
    # 	my$stepup=$lin*4*10;
	#system("bash genotype_identifier_10X.sh $stepup $file");
	#print "bash genotype_identifier.sh $stepup $file\n";
    #}
}
	

print "ID\tGenotype\tSupportReads\t%MappedSupport\t%Mapped\tLinesUsed\n";
open (SAM, "$ARGV[0]") or die;
while (my $line = <SAM>) {
    chomp $line;
    my@data=split('\t',$line);
    if (defined $data[1]) {
	if($data[1] eq "*"){$unmapped=$data[0];}
	else{push(@counts,$data[0]);push(@references,$data[1]);}
    }
    else{
	if(defined $references[1]){
	    callgenotype();
	    $file="";@references=();@counts=();$unmapped=0;
	}
	$file=substr($line,2,100);
    }
}close (SAM);
callgenotype();
