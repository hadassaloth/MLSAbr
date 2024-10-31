# !/usr/bin/perl

# INFORMAÇÕES IMPORTANTES, LEIA ANTES DE USAR!!!
# A) Antes de tudo e qualquer coisa, o cabeçalho das sequencias NÃO PODE conter nenhum SÍMBOLO, apenas letras e números sem espaço
# Para isso, escrevi um código em etapas disopnível em: https://github.com/hadassaloth/MLSAbr/

# B) Esse código JÁ FOI convertido com o comando abaixo, para ser utilizado em LINUX:
#dos2unix concatenate_align.pl

# C) Esse código deve ser executado a partir do comando abaixo:
#perl concatenate_align.pl --extension .extensãodassequencias


# Reads in several alignments in the extension spcefied by the user. Concatenates all sequences that have the same id and description
use warnings;
use strict;
use Getopt::Long;
use Bio::SeqIO;
 
my $extension;
 
 
GetOptions('extension=s' => \$extension);
 
my @files = glob("*$extension");
my $count = @files;
print "Processing $count files.\n";
 
my $output_obj = Bio::SeqIO->new(-file => ">Concatenated.algn", -format => "fasta"); 
 
my %concats;
 
foreach my $file (@files) {
    my $seq_count = 0;
    my $input_obj = Bio::SeqIO->new(-file => "<$file", -format => "fasta");
    while (my $seq_obj = $input_obj->next_seq) {
        #Read one sequence at a atime. Merge id and desc in a string,remove spaces and use the new string as the id for the output sequence. Hold the concatenates in %concats
        my $id = $seq_obj->id;
        print "$id\n";
        $id =~ s/\s/_/g;
        my @words = split /\_/, $id;
        my $taxon = $words[0];
        print "Taxon is $taxon\n";
        my $seq = $seq_obj->seq;
        $concats{$taxon} .= $seq;
        $seq_count++;
 
    }
    print "Retrieved $seq_count sequences from $file.\n";
}
 
 
my $tax_count = keys %concats;
print "$tax_count taxons detected:\n";
 
#print to output
foreach my $taxon (keys %concats) {
    print "$taxon\n";
    my $seq_obj = Bio::Seq->new(-id => $taxon, -seq => $concats{$taxon});
    $output_obj->write_seq($seq_obj);
}

