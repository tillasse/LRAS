#!/usr/bin/perl
use strict;
use warnings;

# Quelques fa�ons d'utiliser ce module.

# Moduke Bio ::DB ::GenBank
use Bio::DB::GenBank;

# Cr�ation du handle permettant de se connecter � la banque de donn�es GenBank avec le constructeur new qui ne prend aucun argument
my $gb = new Bio::DB::GenBank;

# R�cup�ration des informations relatives � une s�quence en introduisant son Accession Number
# Utilisation de la m�thode get_Seq_by_acc avec en argument l'accession demand�
my $seq = $gb->get_Seq_by_acc('J00522');

# Requ�te plus complexe via la m�thode Bio::DB::Query::GenBank
# Plusieurs param�tres tels que la banque de donn�es � interroger
# Renvoi d'un flux d'objets Bio::SeqIO
my $query = Bio::DB::Query::GenBank->new
(-query   =>'Oryza sativa[Organism] AND EST',
 -reldate => '30',
 -db      => 'nucleotide');

# Stockage des diff�rentes s�quences correspondant � ces crit�res dans la variable $seqio
my $seqio = $gb->get_Stream_by_query($query);

# Gr�ce � une boucle r�cup�ration un � un des objets correspondant aux diff�rentes s�quences
# Obtention des informations comme par exemple la longueur de la s�quence.
while( my $seq =  $seqio->next_seq ) {
print "seq length is ", $seq->length,"\n";
print "seq length is ", $seq->desc(),"\n";
}

# Liste d'accessions par la m�thode get_Stream_by_acc
# avec en argument la liste des accession
    my $seqio2 = $gb->get_Stream_by_acc(['AC013798', 'AC021953'] );
    while( my $clone =  $seqio2->next_seq ) {
      print "cloneid is ", $clone->display_id, " ",
             $clone->accession_number, "\n";
    }

