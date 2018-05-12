#!/usr/bin/perl
use strict;
use warnings;

# Quelques façons d'utiliser ce module.

# Moduke Bio ::DB ::GenBank
use Bio::DB::GenBank;

# Création du handle permettant de se connecter à la banque de données GenBank avec le constructeur new qui ne prend aucun argument
my $gb = new Bio::DB::GenBank;

# Récupération des informations relatives à une séquence en introduisant son Accession Number
# Utilisation de la méthode get_Seq_by_acc avec en argument l'accession demandé
my $seq = $gb->get_Seq_by_acc('J00522');

# Requête plus complexe via la méthode Bio::DB::Query::GenBank
# Plusieurs paramètres tels que la banque de données à interroger
# Renvoi d'un flux d'objets Bio::SeqIO
my $query = Bio::DB::Query::GenBank->new
(-query   =>'Oryza sativa[Organism] AND EST',
 -reldate => '30',
 -db      => 'nucleotide');

# Stockage des différentes séquences correspondant à ces critères dans la variable $seqio
my $seqio = $gb->get_Stream_by_query($query);

# Grâce à une boucle récupération un à un des objets correspondant aux différentes séquences
# Obtention des informations comme par exemple la longueur de la séquence.
while( my $seq =  $seqio->next_seq ) {
print "seq length is ", $seq->length,"\n";
print "seq length is ", $seq->desc(),"\n";
}

# Liste d'accessions par la méthode get_Stream_by_acc
# avec en argument la liste des accession
    my $seqio2 = $gb->get_Stream_by_acc(['AC013798', 'AC021953'] );
    while( my $clone =  $seqio2->next_seq ) {
      print "cloneid is ", $clone->display_id, " ",
             $clone->accession_number, "\n";
    }

