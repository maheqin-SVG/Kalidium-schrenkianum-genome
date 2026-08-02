use strict;
use warnings;
use Bio::SeqIO;

my $in=shift or die "perl $0 infile\n";
my $fa=Bio::SeqIO->new(-file=>"$in",-format=>"fasta");
while (my $seq=$fa->next_seq) {
    my $id=$seq->id;
    my $desc=$seq->desc;
    my $seq=$seq->seq;
    $seq=~s/\*$//;
    $seq=~s/\*//g;
    print ">$id $desc\n$seq\n";
}
