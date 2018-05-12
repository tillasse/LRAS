#!/usr/bin/perl


my $seqio_object = Bio::SeqIO->new(-file   => 'ref_chr1.gbk', -format => "genbank");

my $seq_object = $seqio_object->next_seq;

for my $feat_object ($seq_object->get_SeqFeatures)
{
   if ($feat_object->primary_tag eq "exon")
   {


      if ($feat_object->has_tag('gene'))
      {
         for my $val ($feat_object->get_tag_values('gene'))
         {



            #
$ID_GENE=;
$TYPE_REGIONS="exon";
$ID_SEQ_REGION=$val;
$SEQ_REGION=$feat_object->spliced_seq->seq;
$ID_GENE= <<"SQL";
SELECT ID_GENES from GENES where NOM_GENES='$ID_SEQ_REGION';
SQL
 $dbh->do($ID_GENE)


my  $SQLCreationTablesSEQUENCES = <<"SQL";
  INSERT INTO SEQUENCES ( ID_GENE,TYPE_REGIONS,ID_SEQ_REGION,SEQ_REGION)
  VALUES ( '$ID_GENE','$TYPE_REGIONS','$ID_SEQ_REGION','$SEQ_REGION');
SQL
 #$dbh->do($RequeteSQL) or die "Echec Requete $RequeteSQL : $DBI::errstr";
 $dbh->do($SQLCreationTablesSEQUENCES)
    or die "Impossible de creer la table \n\n";

if($ID_SEQ_REGION==$NOM_GENES){
$ID_GENE(region)=$ID_GENE





         }
      }
   }
}
