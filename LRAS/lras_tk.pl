#!/usr/bin/perl

use Tk ;
use Bio::Seq;
use Bio::Perl;
use Bio::SeqIO;
use Bio::DB::GenBank;
use Bio::SeqFeature::Annotated  ;
use Bio::SeqFeature::Generic;
use Bio::Seq RichSeq ;
use DBI;

#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Fenêtre principale~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$f = MainWindow->new(-background=>'#e8e8e8');
     $f->geometry('600x400');
     $f->title("LRAS(v2)");
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~labFrame_ouvrir~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$boutton0 = $f -> LabFrame (
                    -label=>'LRAS',
                    -background=>'#e8e8e8',
                    -foreground => 'Blue',
                    -labelside=>'acrosstop',
                    -relief => 'groove' ,
                    -borderwidth => 2 )
               -> pack ( -side => 'top' ,
                         -anchor => 'nw' ,
                         -expand => 1 ,
                         -fill => 'x' ) ;

#------------------------------------------------frame_option
$boutton3 = $boutton0 -> LabFrame (
                           -label=>'Options',
                           -background=>'#e8e8e8',
                           -labelside=>'acrosstop',
                           -relief => 'groove' ,
                           -borderwidth => 2 )
                      -> pack ( -side => 'bottom' ,
                                -anchor => 'n' ,
                                -expand => 1 ,
                                -fill => 'x' ) ;
#------------------------------------------------button_quiter
$btn_modif = $f -> Button (
                            -text => 'Quiter' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -background => 'blue',
                            -activebackground => 'blue',
                            -command => sub{exit();} )
                       -> pack ( -side => 'bottom',
                                 -anchor => 'n',
                                 -fill => 'both' ) ;

#------------------------------------------------frame_fasta

$boutton4 = $boutton0 -> LabFrame (
                           -label=>'fasta',
                           -background=>'#e8e8e8',
                           -labelside=>'acrosstop',
                           -relief => 'groove' ,
                           -borderwidth => 2 )
                      -> pack ( -side => 'bottom' ,
                                -anchor => 'sw' ,
                                -expand => 1 ,
                                -fill => 'x' ) ;

#------------------------------------------------frame_option

$boutton1 = $boutton0 -> LabFrame (
                           -label=>'Ouvrir',
                           -background=>'#e8e8e8',
                           -labelside=>'acrosstop',
                           -relief => 'groove' ,
                           -borderwidth => 2 )
                      -> pack ( -side => 'bottom' ,
                                -anchor => 'sw' ,
                                -expand => 1 ,
                                -fill => 'x' ) ;

#------------------------------------------------label_Entrez l\'ID....

$message1 = $boutton1 -> Label (
                           -text => ' Ouvrir un fichier FASTA',
                           -background=>'#e8e8e8',   )
                      -> pack (-side => 'left',
                               -anchor => 'w' ) ;
#------------------------------------------------button_parcourir
$btn_modif = $boutton1 -> Button (
                            -text => 'Parcourir' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&Ouvrir )
                       -> pack ( -side => 'right',
                                 -anchor => 'w' ) ;

#------------------------------------------------button_vider
$btn_modif = $boutton1 -> Button (
                            -text => 'Vider' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&supprimer )
                       -> pack ( -side => 'right',
                                 -anchor => 'w' ) ;

#------------------------------------------------Entry
$zone_saisie2 = $boutton1 -> Entry ( )
                          ->pack(-side=>'right',
                                 -expand => 1,
                                 -fill => 'x');
#------------------------------------------------label_lras ...
$code_font = $f->fontCreate('code', -family => 'courier',
                             -size => 20);

$message1 = $boutton0 -> Label (
                           -text => "LRAS ",
                           -foreground => 'Blue',
                           -font => $code_font)
                      ->pack(-side=>"top",
                             -anchor => 'nw',
                             -anchor => 'center') ;

$message5 = $boutton0 -> Label (
                           -text => "(logiciel de recherche et d'analyse des séquences) ",
                           -font => 10)
                      ->pack(-side=>"top",
                             -anchor => 'nw',
                             -anchor => 'center') ;
#------------------------------------------------LabFrame_Options

$boutton2 = $boutton0 -> LabFrame (
                           -label=>'Options',
                           -background=>'#e8e8e8',
                           -labelside=>'acrosstop',
                           -relief => 'groove' ,
                           -borderwidth => 2 )
                      -> pack ( -side => 'bottom' ,
                                -anchor => 'sw' ,
                                -expand => 1 ,
                                -fill => 'x' ) ;
#------------------------------------------------Button_SSR+primer
$btn_modif = $boutton2 -> Button (
                            -text => 'SSR+Primer' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&ssr )
                       -> pack ( -side => 'right',
                                 -anchor => 'w',
                                 -fill => 'both',
                                 -expand => 1  ) ;


#------------------------------------------------Button_SSR
$btn_modif = $boutton2 -> Button (
                            -text => 'SSR' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&simple_ssr )
                       -> pack ( -side => 'right',
                                 -anchor => 'w',
                                 -fill => 'both',
                                 -expand => 1  ) ;


#------------------------------------------------Button_SSR_bdd
$btn_modif = $boutton2 -> Button (
                            -text => 'base de donnee:SSR' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&ssr_bdd )
                       -> pack ( -side => 'right',
                                 -anchor => 'w',
                                 -fill => 'both',
                                 -expand => 1  ) ;
#------------------------------------------------Button_info
$btn_modif = $boutton2 -> Button (
                            -text => 'Info' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&info )
                       -> pack ( -side => 'right',
                                 -anchor => 'w',
                                 -fill => 'both' ) ;

#------------------------------------------------Button_gb_fasta
$btn_modif = $boutton2 -> Button (
                            -text => 'Genbank-->Fasta' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&gb_fasta  )
                       -> pack ( -side => 'right',
                                 -anchor => 'w',
                                 -fill => 'both' ) ;
#------------------------------------------------Button_fragmenter
$btn_modif = $boutton2 -> Button (
                            -text => 'Fragmenter' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&fragmenter )
                       -> pack ( -side => 'right',
                                 -anchor => 'w',
                                 -fill => 'both' ) ;
#------------------------------------------------Button_excel
$btn_modif1 = $boutton2 -> Button (
                             -text => 'Excel' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -command => \&excel )
                        -> pack ( -side => 'left',
                                  -anchor => 'w',
                                  -fill => 'both' ) ;
#------------------------------------------------Button_blast

$btn_modif1 = $boutton3 -> Button (
                             -text => 'Blast' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -activebackground => 'red',
                             -activeforeground => 'blue',
                             -command => \&blast )
                        -> pack ( -side => 'left',
                                  -expand => 1 ,
                                  -anchor => 'center',
                                  -fill => 'both' ) ;
#------------------------------------------------Button_genpept_genbank

$btn_modif1 = $boutton3 -> Button (
                             -text => 'GenPept-->GenBank' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -activebackground => 'red',
                             -activeforeground => 'blue' ,
                             -command => \&genpept_genbank   )
                        -> pack ( -side => 'left',
                                  -expand => 1 ,
                                  -anchor => 'w',
                                  -fill => 'both' ) ;

#------------------------------------------------Button_GenPept_NCBI_CDS

$btn_modif1 = $boutton3 -> Button (
                             -text => 'GenPept-->NCBI-->CDS' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -activebackground => 'red',
                             -activeforeground => 'blue',
                             -command => \&GenPept_NCBI_CDS   )
                        -> pack ( -side => 'left',
                                  -anchor => 'w' ,
                                  -expand => 1   ,
                                  -fill => 'both' ) ;

#------------------------------------------------Button_gene

$btn_modif1 = $boutton4 -> Button (
                             -text => 'gene' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -activebackground => 'red',
                             -activeforeground => 'blue',
                             -command => \&gene)
                        -> pack ( -side => 'left',
                                  -expand => 1 ,
                                  -anchor => 'center',
                                  -fill => 'both' ) ;

#------------------------------------------------Button_cds

$btn_modif1 = $boutton4 -> Button (
                             -text => 'cds' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -activebackground => 'red',
                             -activeforeground => 'blue',
                             -command => \&cds )
                        -> pack ( -side => 'left',
                                  -expand => 1 ,
                                  -anchor => 'center',
                                  -fill => 'both' ) ;

#------------------------------------------------Button_exon

$btn_modif1 = $boutton4 -> Button (
                             -text => 'exon' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -activebackground => 'red',
                             -activeforeground => 'blue',
                             -command => \&exon )
                        -> pack ( -side => 'left',
                                  -expand => 1 ,
                                  -anchor => 'center',
                                  -fill => 'both' ) ;

#------------------------------------------------Button_intron

$btn_modif1 = $boutton4 -> Button (
                             -text => 'intron' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -activebackground => 'red',
                             -activeforeground => 'blue',
                             -command => \&intron )
                        -> pack ( -side => 'left',
                                  -expand => 1 ,
                                  -anchor => 'center',
                                  -fill => 'both' ) ;

#------------------------------------------------Button_all

$btn_modif1 = $boutton4 -> Button (
                             -text => 'all' ,
                             -background=>'#e8e8e8',
                             -relief => 'groove' ,
                             -activebackground => 'red',
                             -activeforeground => 'blue',
                             -command => \&all )
                        -> pack ( -side => 'left',
                                  -expand => 1 ,
                                  -anchor => 'center',
                                  -fill => 'both' ) ;

#------------------------------------------------frame_BDD

$boutton_B1 = $f -> LabFrame (
                           -label=>'BDD',
                           -background=>'#e8e8e8',
                           -labelside=>'acrosstop',
                           -relief => 'groove' ,
                           -borderwidth => 2 )
                      -> pack ( -side => 'top' ,
                                -anchor => 'sw' ,
                                -expand => 1 ,
                                -fill => 'x' ) ;

#------------------------------------------------label_Entrez l\'ID....

$message_B1 = $boutton_B1 -> Label (
                           -text => ' Entrez l\'ID',
                           -background=>'#e8e8e8',   )
                      -> pack (-side => 'left',
                               -anchor => 'w' ) ;
#------------------------------------------------button_ACTION_BDD
$btn_modif_B1 = $boutton_B1 -> Button (
                            -text => 'ACTION' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => \&BDD )
                       -> pack ( -side => 'right',
                                 -anchor => 'w' ) ;

#------------------------------------------------button_vider
$btn_modif_B2 = $boutton_B1 -> Button (
                            -text => 'Vider' ,
                            -background=>'#e8e8e8',
                            -relief => 'groove' ,
                            -command => sub{$zone_saisie_B1->delete('0.0','end');})
                       -> pack ( -side => 'right',
                                 -anchor => 'w' ) ;

#------------------------------------------------Entry
$zone_saisie_B1 = $boutton_B1 -> Entry ( )
                          ->pack(-side=>'right',
                                 -expand => 1,
                                 -fill => 'x');

#------------------------------------------------Text

$t = $f -> Scrolled ('Text' ,
                        -scrollbars => 'se' ,
                        -width => 100 ,
                        -height => 25 ,
                        -tabs => [ '3' ])
        -> pack ( -fill => 'x' ) ;

#------------------------------------------------
MainLoop;


#-------------------------------------------------------------------------------

#*******************************************************************************
sub Ouvrir{
        $nom_fichier = $f -> getOpenFile ( -initialdir => 'c:\\' );
        $nom_fichier =~ tr/\//\\/;
        $zone_saisie2 -> insert ( 'end' , "$nom_fichier" ) ;
        #return $nom_fichier;
 }

#*******************************************************************************
sub supprimer{
$zone_saisie2->delete('0.0','end');
}

 sub ssr{

$filename = $nom_fichier;
chomp($filename);
open(NAM,">filename.tmp")|| die ("\nError: temp/filename.tmp file doesn't exist !\n\n");
#system("attrib +h filename.tmp");
print NAM $filename;
close NAM;
#===============================================================================
$a=1;
#==============================# Open FASTA file #==============================

open (IN,"<$filename") || die ("\nError: FASTA file doesn't exist !\n\n");
open (OUT,">$filename.lras")|| die ("\nError: misa file doesn't exist !\n\n");
print OUT "ID\tSSR_nr.\tSSR_type\tSSR\tsize\tstart\tend\n";
#===============================================================================

#==============================# Reading arguments #============================
open (SPECS,"../lib/lras.ini") || die ("\nError: Specifications file doesn't exist !\n\n");
my %typrep;
my $amb = 0;
while (<SPECS>)
   {
   %typrep = $1 =~ /(\d+)/gi if (/^def\S*\s+(.*)/i);
   if (/^int\S*\s+(\d+)/i) {$amb = $1}
   };
my @typ = sort { $a <=> $b } keys %typrep;
#§§§§§ CORE §§§§§#

$/ = ">";
my $max_repeats = 1; #count repeats
my $min_repeats = 1000; #count repeats
my (%count_motif,%count_class); #count
my ($number_sequences,$size_sequences,%ssr_containing_seqs); #stores number and size of all sequences examined
my $ssr_in_compound = 0;
my ($id,$seq);
while (<IN>)
  {
  next unless (($id,$seq) = /(.*?)\n(.*)/s);
  my ($nr,%start,@order,%end,%motif,%repeats); # store info of all SSRs from each sequence
  $seq =~ s/[\d\s>]//g; #remove digits, spaces, line breaks,...
  $id =~ s/^\s*//g; $id =~ s/\s*$//g;$id =~ s/\s/_/g; #replace whitespace with "_"
  $number_sequences++;
  $size_sequences += length $seq;
  for ($i=0; $i < scalar(@typ); $i++) #check each motif class
    {
    my $motiflen = $typ[$i];
    my $minreps = $typrep{$typ[$i]} - 1;
    if ($min_repeats > $typrep{$typ[$i]}) {$min_repeats = $typrep{$typ[$i]}}; #count repeats
    my $search = "(([acgt]{$motiflen})\\2{$minreps,})";
    while ( $seq =~ /$search/ig ) #scan whole sequence for that class
      {
      my $motif = uc $2;
      my $redundant; #reject false type motifs [e.g. (TT)6 or (ACAC)5]
      for ($j = $motiflen - 1; $j > 0; $j--)
        {
        my $redmotif = "([ACGT]{$j})\\1{".($motiflen/$j-1)."}";
        $redundant = 1 if ( $motif =~ /$redmotif/ )
        };
      next if $redundant;
      $motif{++$nr} = $motif;
      my $ssr = uc $1;
      $repeats{$nr} = length($ssr) / $motiflen;
      $end{$nr} = pos($seq);
      $start{$nr} = $end{$nr} - length($ssr) + 1;
      # count repeats
      $count_motifs{$motif{$nr}}++; #counts occurrence of individual motifs
      $motif{$nr}->{$repeats{$nr}}++; #counts occurrence of specific SSR in its appearing repeat
      $count_class{$typ[$i]}++; #counts occurrence in each motif class
      if ($max_repeats < $repeats{$nr}) {$max_repeats = $repeats{$nr}};
      };
    };
  next if (!$nr); #no SSRs
  $ssr_containing_seqs{$nr}++;
  @order = sort { $start{$a} <=> $start{$b} } keys %start; #put SSRs in right order
  $i = 0;
  my $count_seq; #counts
  my ($start,$end,$ssrseq,$ssrtype,$size);
  while ($i < $nr)
    {
    my $space = $amb + 1;
    if (!$order[$i+1]) #last or only SSR
      {
      $count_seq++;
      my $motiflen = length ($motif{$order[$i]});
      $ssrtype = "p".$motiflen;
      $ssrseq = "($motif{$order[$i]})$repeats{$order[$i]}";
      $start = $start{$order[$i]}; $end = $end{$order[$i++]};
      next
      };
    if (($start{$order[$i+1]} - $end{$order[$i]}) > $space)
      {
      $count_seq++;
      my $motiflen = length ($motif{$order[$i]});
      $ssrtype = "p".$motiflen;
      $ssrseq = "($motif{$order[$i]})$repeats{$order[$i]}";
      $start = $start{$order[$i]}; $end = $end{$order[$i++]};
      next
      };
    my ($interssr);
    if (($start{$order[$i+1]} - $end{$order[$i]}) < 1)
      {
      $count_seq++; $ssr_in_compound++;
      $ssrtype = 'c*';
      $ssrseq = "($motif{$order[$i]})$repeats{$order[$i]}($motif{$order[$i+1]})$repeats{$order[$i+1]}*";
      $start = $start{$order[$i]}; $end = $end{$order[$i+1]}
      }
    else
      {
      $count_seq++; $ssr_in_compound++;
      $interssr = lc substr($seq,$end{$order[$i]},($start{$order[$i+1]} - $end{$order[$i]}) - 1);
      $ssrtype = 'c';
      $ssrseq = "($motif{$order[$i]})$repeats{$order[$i]}$interssr($motif{$order[$i+1]})$repeats{$order[$i+1]}";
      $start = $start{$order[$i]};  $end = $end{$order[$i+1]};
      #$space -= length $interssr
      };
    while ($order[++$i + 1] and (($start{$order[$i+1]} - $end{$order[$i]}) <= $space))
      {
      if (($start{$order[$i+1]} - $end{$order[$i]}) < 1)
        {
        $ssr_in_compound++;
        $ssrseq .= "($motif{$order[$i+1]})$repeats{$order[$i+1]}*";
        $ssrtype = 'c*';
        $end = $end{$order[$i+1]}
        }
      else
        {
        $ssr_in_compound++;
        $interssr = lc substr($seq,$end{$order[$i]},($start{$order[$i+1]} - $end{$order[$i]}) - 1);
        $ssrseq .= "$interssr($motif{$order[$i+1]})$repeats{$order[$i+1]}";
        $end = $end{$order[$i+1]};
        #$space -= length $interssr
        }
      };
    $i++;
    }
  continue
    {
#===============================printer le resultat=============================
    print OUT "$id\t$count_seq\t$ssrtype\t$ssrseq\t",($end - $start + 1),"\t$start\t$end\n" ;
    open(RES,">>$a");
    print RES "PRIMER_SEQUENCE_ID=$id"."_$count_seq\nSEQUENCE=$seq\n";
    print RES "PRIMER_PRODUCT_SIZE_RANGE=100-280\n";
    print RES "TARGET=",$start-3,",",($end - $start + 1)+6,"\n";
    print RES "PRIMER_MAX_END_STABILITY=250\n=\n" ;
#===============================================================================

#======================================primer3==================================
$p3_core="primer3 <$a> $a.p3out";
system("$p3_core");
#===============================================================================

#===============================supprimer.p3in==================================
close RES;
foreach ("$a")
  {
  unlink($_);
  }
#===============================================================================

#=========================suprimer.p3out(full seq)==============================
open (S, ">a.tmp") || die "Problème pour ouvrir $fichier: ";
print S $a;
$t -> insert ( 'end' , "$a" ) ;#inseret dans la zone de text
#system("cd Mind");
system("perl filtre.pl");
foreach ("$a.p3out")
  {
  unlink($_);
  }
#===============================================================================

$a++;
    }
  }
close (OUT);
open (OUT,">$filename.statistics");

#§§§§§ INFO §§§§§#

#§§§ Specifications §§§#
print OUT "Specifications\n==============\n\nSequence source file: \"$filename\"\n\nDefinement of microsatellites (unit size / minimum number of repeats):\n";
for ($i = 0; $i < scalar (@typ); $i++) {print OUT "($typ[$i]/$typrep{$typ[$i]}) "};print OUT "\n";
if ($amb > 0) {print OUT "\nMaximal number of bases interrupting 2 SSRs in a compound microsatellite:  $amb\n"};
print OUT "\n\n\n";

#§§§ OCCURRENCE OF SSRs §§§#

#small calculations
my @ssr_containing_seqs = values %ssr_containing_seqs;
my $ssr_containing_seqs = 0;
for ($i = 0; $i < scalar (@ssr_containing_seqs); $i++) {$ssr_containing_seqs += $ssr_containing_seqs[$i]};
my @count_motifs = sort {length ($a) <=> length ($b) || $a cmp $b } keys %count_motifs;
my @count_class = sort { $a <=> $b } keys %count_class;
for ($i = 0; $i < scalar (@count_class); $i++) {$total += $count_class{$count_class[$i]}};

#§§§ Overview §§§#
print OUT "RESULTS OF MICROSATELLITE SEARCH\n================================\n\n";
print OUT "Total number of sequences examined:              $number_sequences\n";
print OUT "Total size of examined sequences (bp):           $size_sequences\n";
print OUT "Total number of identified SSRs:                 $total\n";
print OUT "Number of SSR containing sequences:              $ssr_containing_seqs\n";
print OUT "Number of sequences containing more than 1 SSR:  ",$ssr_containing_seqs - ($ssr_containing_seqs{1} || 0),"\n";
print OUT "Number of SSRs present in compound formation:    $ssr_in_compound\n\n\n";

#§§§ Frequency of SSR classes §§§#
print OUT "Distribution to different repeat type classes\n---------------------------------------------\n\n";
print OUT "Unit size\tNumber of SSRs\n";
my $total = undef;
for ($i = 0; $i < scalar (@count_class); $i++) {print OUT "$count_class[$i]\t$count_class{$count_class[$i]}\n"};
print OUT "\n";

#§§§ Frequency of SSRs: per motif and number of repeats §§§#
print OUT "Frequency of identified SSR motifs\n----------------------------------\n\nRepeats";
for ($i = $min_repeats;$i <= $max_repeats; $i++) {print OUT "\t$i"};
print OUT "\ttotal\n";
for ($i = 0; $i < scalar (@count_motifs); $i++)
  {
  my $typ = length ($count_motifs[$i]);
  print OUT $count_motifs[$i];
  for ($j = $min_repeats; $j <= $max_repeats; $j++)
    {
    if ($j < $typrep{$typ}) {print OUT "\t-";next};
    if ($count_motifs[$i]->{$j}) {print OUT "\t$count_motifs[$i]->{$j}"} else {print OUT "\t"};
    };
  print OUT "\t$count_motifs{$count_motifs[$i]}\n";
  };
print OUT "\n";

#§§§ Frequency of SSRs: summarizing redundant and reverse motifs §§§#
# Eliminates %count_motifs !
print OUT "Frequency of classified repeat types (considering sequence complementary)\n-------------------------------------------------------------------------\n\nRepeats";
my (%red_rev,@red_rev); # groups
for ($i = 0; $i < scalar (@count_motifs); $i++)
  {
  next if ($count_motifs{$count_motifs[$i]} eq 'X');
  my (%group,@group,$red_rev); # store redundant/reverse motifs
  my $reverse_motif = $actual_motif = $actual_motif_a = $count_motifs[$i];
  $reverse_motif =~ tr/ACGT/TGCA/;
  my $reverse_motif_a = $reverse_motif;
  for ($j = 0; $j < length ($count_motifs[$i]); $j++)
    {
    if ($count_motifs{$actual_motif}) {$group{$actual_motif} = "1"; $count_motifs{$actual_motif}='X'};
    if ($count_motifs{$reverse_motif}) {$group{$reverse_motif} = "1"; $count_motifs{$reverse_motif}='X'};
    $actual_motif =~ s/(.)(.*)/$2$1/;
    $reverse_motif =~ s/(.)(.*)/$2$1/;
    $actual_motif_a = $actual_motif if ($actual_motif lt $actual_motif_a);
    $reverse_motif_a = $reverse_motif if ($reverse_motif lt $reverse_motif_a)
    };
  if ($actual_motif_a lt $reverse_motif_a) {$red_rev = "$actual_motif_a/$reverse_motif_a"}
  else {$red_rev = "$reverse_motif_a/$actual_motif_a"}; # group name
  $red_rev{$red_rev}++;
  @group = keys %group;
  for ($j = 0; $j < scalar (@group); $j++)
    {
    for ($k = $min_repeats; $k <= $max_repeats; $k++)
      {
      if ($group[$j]->{$k}) {$red_rev->{"total"} += $group[$j]->{$k};$red_rev->{$k} += $group[$j]->{$k}}
      }
    }
  };
for ($i = $min_repeats; $i <= $max_repeats; $i++) {print OUT "\t$i"};
print OUT "\ttotal\n";
@red_rev = sort {length ($a) <=> length ($b) || $a cmp $b } keys %red_rev;
for ($i = 0; $i < scalar (@red_rev); $i++)
  {
  my $typ = (length ($red_rev[$i])-1)/2;
  print OUT $red_rev[$i];
  for ($j = $min_repeats; $j <= $max_repeats; $j++)
    {
    if ($j < $typrep{$typ}) {print OUT "\t-";next};
    if ($red_rev[$i]->{$j}) {print OUT "\t",$red_rev[$i]->{$j}}
    else {print OUT "\t"}
    };
  print OUT "\t",$red_rev[$i]->{"total"},"\n";
  };
  close OUT;
  system("perl p3_out.pl");
 }

sub excel{
$filename=$nom_fichier;
open(SRC,"<$filename")|| die ("\nError: temp/filename.tmp file doesn't exist !\n\n");
open(CSV,">>$filename.csv")|| die ("\nError: temp/filename.tmp file doesn't exist !\n\n");
while($ligne=<SRC>){
$ligne=~ s/\s/;/g;
print CSV "$ligne"."\n";

}
close SRC ;
close CSV ;
}

sub blast{

$seqio  = Bio::SeqIO->new( '-format' => 'FASTA' , -file => "$nom_fichier");

      while ( $seqobj = $seqio->next_seq() ) {
       $blast_result = blast_sequence($seqobj);

       write_blast(">>$nom_fichier.blast",$blast_result);


    }
    }



sub genpept_genbank{

################################################################################
$filename=$nom_fichier;
open (CSV ,">>$filename.csv");
print CSV "id;taille;descreption\n";
my $seqio_object = Bio::SeqIO->new(-file => "$filename",
                                   -format => 'GenBank');
while ( $seq_object = $seqio_object->next_seq ) {
    for my $feat_object ($seq_object->get_SeqFeatures) {
      if ($feat_object->primary_tag eq "CDS") {
           #print $feat_object->spliced_seq->seq,"\n";
           # e.g. 'ATTATTTTCGCTCGCTTCTCGCGCTTTTTGAGATAAGGTCGCGT...'
      if ($feat_object->has_tag('coded_by')) {
         for my $val ($feat_object->get_tag_values('coded_by')){
             "gene: ",$val,"\n";
              $b=$val;
              $b =~ /([A-Z][A-Z])+(\w*)(\.)(\d)/;
    $b1=$1;
    $b2=$2;
    $b3=$3;
    $b4=$4;
    $a="$b1"."$b2"."$b3"."$b4"."\n";
            # e.g. 'NDP', from a line like '/gene="NDP"'
         }
      }
   }
}
 $gb = new Bio::DB::GenBank;
 $seq1 = $gb->get_Seq_by_acc("$a");
  my $out = Bio::SeqIO->new(-format => 'genbank',
                            -file => ">>$filename.out.gb");
  $out->write_seq($seq1);

 print  CSV $gi1 = $seq1->primary_id().";";
 print  CSV $length1 = $seq1->length.";";
 print  CSV $description1 = $seq1->desc()."\n";

}
}




sub GenPept_NCBI_CDS{

$monfichier_in = $nom_fichier;#file input
open (file ,">$monfichier_in-CDS-V1.txt")|| die ("\nError: temp/filename.tmp file doesn't exist !\n\n");#file output

my $seqio_object = Bio::SeqIO->new(-file => "$monfichier_in",
                                   -format => 'GenBank');

while ( $seq_object = $seqio_object->next_seq ) {
$acc_old_p = $seq_object->accession; #acc_old_p=accession_old_proteine
$acc_new_p = $acc_old_p.".1";

print  file "proteine_id : $acc_new_p\n";

        for my $feat_object ($seq_object->get_SeqFeatures) {

          if ($feat_object->primary_tag eq "CDS")
             {
                if ($feat_object->has_tag('coded_by'))
                   {
                  for my $val ($feat_object->get_tag_values('coded_by'))
                      {
                     #"gene: ",$val,"\n";
                      $b=$val;
                      $b =~ /([A-Z][A-Z])+(\w*)(\.)(\d)/;
                      $b1=$1;
                      $b2=$2;
                      $b3=$3;
                      $b4=$4;
                      $cds_id ="$b1"."$b2"."$b3"."$b4";
                      print  file "CDS_id : $cds_id\n";

                      }
                   }

###############################################################################

$gb = new Bio::DB::GenBank;
$seq1 = $gb->get_Seq_by_acc("$cds_id");
#------------------------------------------------------------------------------


for my $feat_object ($seq1->get_SeqFeatures)
    {
     if ($feat_object->primary_tag eq "CDS")
        {
           #print $feat_object->spliced_seq->seq,"\n";
           # e.g. 'ATTATTTTCGCTCGCTTCTCGCGCTTTTTGAGATAAGGTCGCGT...'
          if ($feat_object->has_tag('protein_id'))
             {
              for my $val ($feat_object->get_tag_values('protein_id'))
                  {
                   if($val eq "$acc_new_p")
                     {
                       #print "gene: ",$val,"\n";
                       $seq=$feat_object->spliced_seq->seq,"\n";
                       $length1 =length($seq);
                       print file "length: $length1\n";
                       print file "sequence=$seq\n\n";
                       print file "==============================================\n";
                     }


                  }
             }

        }
     }
}


 #print   $gi1 = $seq1->primary_id().";";
 #print   $length1 = $seq1->length.";";
 #print  f $description1 = $seq1->desc()."\n";
 }
 }
 close file;
}


sub info {
$filename = $nom_fichier;
chomp($filename);
open (IN,"<$filename") || die ("\nError: FASTA file doesn't exist !\n\n");
$nub_ligne=0;
$nub_seq=0;
while($ligne=<IN>){
if($ligne=~ /^\>/){
$nub_seq++;
}
$nub_ligne++;
#print ".";
}
print "nobre de ligne du fichier $filename est : $nub_ligne\n" ;
print "nobre de sequences dans le fichier $filename est : $nub_seq\n" ;
$t -> insert ( 'end' , "nobre de lignes     : $nub_ligne\n" ) ;
$t -> insert ( 'end' , "nobre de sequences  : $nub_seq\n" ) ;

}


sub fragmenter{

$filename = $nom_fichier;
open (IN,"<$filename") || die ("\nError: FASTA file doesn't exist !\n\n");
$a=0;
$i=0;
while (my $ligne = <IN>) {
if(($ligne =~ /^\>/)and ($i==1)){
#mkdir("../input/frag/");
$a++;
$i=0;
if($a==1){
exit;
}
open(f,">>$a");
print f $ligne;
}elsif($ligne =~ /^\>/){
#mkdir("../input/frag/");
open(f,">>$a");
$i++;
print f $ligne;
}else{
#mkdir("../input/frag/");
open(f,">>$a");
print f $ligne;
}
}
}

sub gb_fasta{
$filename = $nom_fichier;

my $seq_in = Bio::SeqIO->new(-file => "$filename", -format => 'genbank');
my $seq_out = Bio::SeqIO->new(-file => ">$filename.fasta", -format => 'fasta');

while ( $seq = $seq_in->next_seq() )
{
$seq_out ->write_seq ( $seq ) ;
}
}

sub ssr_bdd{
# Parametres de connexion à la base de données
my $BaseDeDonnees = "said";
my $NomHote       = "localhost"; # Il est possible de mettre une adresse IP
my $login         = "root";      # login
my $MotDePass     = "";          # Nous n'avons pas de mot de pass




# Connection à la base de données mysql
my $dbh = DBI->connect( "dbi:mysql:dbname=$BaseDeDonnees;host=$NomHote;",
    $login, $MotDePass )
    or die "Connection impossible à la base de donnees $BaseDeDonnees !";



# Creation des tables
print "Creation de la table SSR\n";
my $SQLCreationTablesSSR = <<"SQL";
CREATE TABLE SSR (
  ACC INT NOT NULL  AUTO_INCREMENT ,
  ID VARCHAR( 250 ) NOT NULL ,
  SSR_nr VARCHAR( 250 ) NOT NULL ,
  SSR_type VARCHAR( 250 ) NOT NULL ,
  SSR VARCHAR( 250 ) NOT NULL ,
  size VARCHAR( 250 ) NOT NULL ,
  start VARCHAR( 250 ) NOT NULL ,
  end VARCHAR( 250 ) NOT NULL ,
  PRIMARY KEY ( ACC )
) COMMENT = 'Les info sur SSR';
SQL

$dbh->do($SQLCreationTablesSSR)
    or die "Impossible de creer la table User\n\n";
#system("del user.txt");
# $a=2;
# open(SRC,">user.txt");
# while($a<10){
# print SRC "$a;mojemmi$a;said$a\n";
# $a++;
# }
# close SRC;

open(SRC,"<$nom_fichier");
while($a=<SRC>){
$a=~ s/\s/;/g;
my@t = split(';',$a);
print $t[0];


# Insertion des données
my$id=$t[0];
my$SSR_nr=$t[1];
my$SSR_type=$t[2];
my$SSR=$t[3];
my$size=$t[4];
my$start=$t[5];
my$end=$t[6];
    my $RequeteSQL = <<"SQL";
  INSERT INTO SSR ( ID, SSR_nr, SSR_type,SSR,size,start,end)
  VALUES ( "$id", "$SSR_nr", "$SSR_type","$SSR","$size","$start","$end" );
SQL
 $dbh->do($RequeteSQL) or die "Echec Requete $RequeteSQL : $DBI::errstr";
 }
}

sub BDD{
$a = $zone_saisie_B1->get( );
 $gb = new Bio::DB::GenBank;
 $seq1 = $gb->get_Seq_by_acc("$a");
  my $out = Bio::SeqIO->new(-format => 'fasta',
                            -file => ">>$a.fasta");
  $out->write_seq($seq1);

    my$id     = $seq1->id();
     my$length = $seq1->length();
    my$desc   = $seq1->desc();
     my$seq    = $seq1->seq();

  # Parametres de connexion à la base de données
my $BaseDeDonnees = "vitis";
my $NomHote       = "localhost"; # Il est possible de mettre une adresse IP
my $login         = "root";      # login
my $MotDePass     = "";          # Nous n'avons pas de mot de pass




# Connection à la base de données mysql
my $dbh = DBI->connect( "dbi:mysql:dbname=$BaseDeDonnees;host=$NomHote;",
    $login, $MotDePass )
    or die "Connection impossible à la base de donnees $BaseDeDonnees !";



# Creation des tables
print "Creation de la table seq\n";
my $SQLCreationTablesseq = <<"SQL";
CREATE TABLE seq (
  ACC INT NOT NULL  AUTO_INCREMENT ,
  ID VARCHAR( 250 ) NOT NULL ,
  LENGTH INT NOT NULL ,
  DESQ VARCHAR( 250 ) NOT NULL ,
  SEQ TEXT NOT NULL ,
  PRIMARY KEY ( ACC )
) COMMENT = 'Les info sur seq';
SQL

$dbh->do($SQLCreationTablesseq)
    or die "Impossible de creer la table seq\n\n";



  my $RequeteSQL = <<"SQL";
  INSERT INTO seq ( ID, LENGTH, DESQ, SEQ )
  VALUES ( "$id", "$length", "$desc", "$seq");
SQL
 $dbh->do($RequeteSQL) or die "Echec Requete $RequeteSQL : $DBI::errstr";

  }

  sub fasta{
($seq,$display_id,$desc,$out_file,$type)=@_;
$seq_obj = Bio::Seq->new(-seq => "$seq",
                         -display_id => "$display_id",
                         -desc => "$desc",
                         -alphabet => "dna" );

$seqio_obj = Bio::SeqIO->new(-file => ">>$out_file.$type.fasta", -format => 'fasta' );

$seqio_obj->write_seq($seq_obj);
$seq_obj = $seqio_obj->next_seq;


}

sub cds{

##fonction qui permet d'extraire les sequences cds contenue dans un fichier genbank(ful)
$out_file=$nom_fichier;
#($out_file)=@_;#variable d'entree
open (OUT,">$out_file.CDS"); #fichie de sortie
my $seqio_object = Bio::SeqIO->new(-file => "$out_file" );
my $seq_object = $seqio_object->next_seq;
print OUT "id\tstart\tend\tPRODUCT\tPROTEIN_ID\tCODON_START\tdb_xref_P\tdb_xref\tgene\tseq\tpro\n";
$i=0;

for my $feat_object ($seq_object->get_SeqFeatures)
{
   if ($feat_object->primary_tag eq "CDS")
   {
      print OUT $i,"\t",$feat_object->start,"\t",$feat_object->end,"\t";
      $i++;
      print "cds numero: $i\n";

      if ($feat_object->has_tag('gene'))
      {
      for my $val1 ($feat_object->get_tag_values('product'))
         { print OUT $val1,"\t",}
          for my $val2 ($feat_object->get_tag_values('protein_id'))
         { print OUT $val2,"\t",}
          for my $val3 ($feat_object->get_tag_values('codon_start'))
         { print OUT $val3,"\t",}
          for my $val4 ($feat_object->get_tag_values('db_xref'))
         { print OUT $val4,"\t",}
         for my $val ($feat_object->get_tag_values('gene'))
         {
            print OUT $val,"\t",
            $seq=$feat_object->spliced_seq->seq,"\t";

            $pro = Bio::Seq->new(
                             -seq => $seq);

              $trans = $pro->translate();
            print OUT $trans->seq,"\n";
            #$seq=$feat_object->spliced_seq->seq;

            $display_id="#$i|VVCH1|".$val ;
            $desc="vv ch1 cds::".$feat_object->start."..".$feat_object->end;
            $start=$feat_object->start;
            $end=$feat_object->end ;
            $seq=$seq_object->subseq($start,$end);
           &fasta($seq,$display_id,$desc,$out_file,"CDS");

         }
      }
   }
}

# ($seq,$display_id,$desc,$out_file)=@_;
}

sub exon{
$out_file=$nom_fichier;
open (OUT,">$out_file.EXON");
my $seqio_object = Bio::SeqIO->new(-file => "$out_file" );
my $seq_object = $seqio_object->next_seq;
print OUT "id\tstart\tend\tgene\tseq\n";
$i=1;
for my $feat_object ($seq_object->get_SeqFeatures)
{
   if ($feat_object->primary_tag eq "exon")
   {
      print OUT $i,"\t",$feat_object->start,"\t",$feat_object->end,"\t";
      $i++;
      print "exon numero: $i\n";


      if ($feat_object->has_tag('gene'))
      {
         for my $val ($feat_object->get_tag_values('gene'))
         {
            print OUT $val,"\t",
            $feat_object->spliced_seq->seq,"\n";
            #$seq=$feat_object->spliced_seq->seq;
            $display_id="#$i|VVCH1|".$val ;
            $desc="vv ch1 exon::".$feat_object->start."..".$feat_object->end;
            $start=$feat_object->start;
            $end=$feat_object->end ;

           $seq=$seq_object->subseq($start,$end);
           &fasta($seq,$display_id,$desc,$out_file,"EXON");

         }
      }
   }
}
}


sub intron{
$out_file=$nom_fichier;
open (OUT,">$out_file.TMP1");
my $seqio_object = Bio::SeqIO->new(-file => "$out_file" );
my $seq_object = $seqio_object->next_seq;



for my $feat_object ($seq_object->get_SeqFeatures) {
   if (($feat_object->primary_tag eq "gene")and($feat_object->has_tag('gene'))  ) {
        for my $val ($feat_object->get_tag_values('gene')){
              print OUT "\n",$val,",";#"gene:",$val,"\t pos:",$feat_object->start,"..",$feat_object->end,"\t:";
              $a=$val;
              $tseq = $seq_object->seq();


              }
              }

      if (($feat_object->primary_tag eq "exon")and($feat_object->has_tag('gene'))  ) {
        for my $val ($feat_object->get_tag_values('gene')){
        if($val==$a){
               print OUT ($feat_object->start)-1,",",($feat_object->end)+1,",";



              }
              }
              }
              }

close OUT;
open(SRC,"<$out_file.TMP1");
open(fatiha,">$out_file.TMP2");
open(SAID,">$out_file.TMP3");
open(fs,">$out_file.INTRON");
print fs "id\tstart\tend\tgene\tseq\n";
$r=0;#id
while($ligne=<SRC>){
if ($ligne =~ m/^\s*$/){ next;
}else{print fatiha $ligne;
@t = split(',',$ligne);
$i=2;
$j=3;


$taille1 = $#t;
while($i<=$taille1){
print SAID $t[0],"\t",$t[$i],"..",$t[$j]."\n";
if ( $t[$j]!=NULL){

$tseq = $seq_object->seq();
$tseq = $seq_object->subseq($t[$i],$t[$j]);
       print "gene numero: $r\n";
       print fs "\n",$r,"\t",$t[0],"\t", $t[$i],"\t",$t[$j],"\t",$tseq;
       $seq=$tseq;
            $display_id="#$r|VVCH1|".$t[0] ;
            $desc="vv ch1 intron::".$t[$i]."..".$t[$j];
           &fasta($seq,$display_id,$desc,$out_file,"INTRON");
       }
$i+=2;
$j+=2;
$r++;

}
next;}
close fatiha;
close SRC;

}
close fs;
close SAID;
close fatiha;
close SRC;
foreach ("$out_file.TMP1")
  {
  unlink($_);
  }
  foreach ("$out_file.TMP2")
  {
  unlink($_);
  }
  foreach ("$out_file.TMP3")
  {
  unlink($_);
  }

}

sub gene{
$out_file=$nom_fichier;
open (OUT,">$out_file.GENE");
my $seqio_object = Bio::SeqIO->new(-file => "$out_file" );
my $seq_object = $seqio_object->next_seq;
print OUT "id\tstart\tend\tnote\tdb_xref\tgene\tseq\n";
$i=1;
for my $feat_object ($seq_object->get_SeqFeatures)
{
   if ($feat_object->primary_tag eq "gene")
   {
      print OUT $i,"\t",$feat_object->start,"\t",$feat_object->end,"\t";
      $i++;
      print "gene numero: $i\n";


      if ($feat_object->has_tag('gene'))
      {
      for my $vall ($feat_object->get_tag_values('note'))
         {
         print OUT $vall,"\t",
         }
         for my $val2 ($feat_object->get_tag_values('db_xref'))
         {
         print OUT $val2,"\t",
         }
         for my $val ($feat_object->get_tag_values('gene'))
         {
            print OUT $val,"\t",
            $feat_object->spliced_seq->seq,"\n";
           # $seq=$feat_object->spliced_seq->seq;

            $display_id="#$i|VVCH1|".$val ;
            $desc="vv ch1 gene::".$feat_object->start."..".$feat_object->end;
            $start=$feat_object->start;
            $end=$feat_object->end ;
            $seq=$seq_object->subseq($start,$end);
           &fasta($seq,$display_id,$desc,$out_file,"GENE");

         }
      }
   }
}
close OUT;
}
sub all_fraq{

$filename=$nom_fichier;
$d=$nom_fichier;
open (IN,"<$filename") || die ("\nError: FASTA file doesn't exist !\n\n");
my $io = Bio::SeqIO->new(-file => $filename, -format => "genbank" );
 $seq_object = $io->next_seq ;
 $accession=  $seq_object->accession;


while (my $ligne = <IN>) {
if($ligne =~ /^\/\//){
close f;
open(said,"<$d"."$accession" );
 print $accession ."\n";
 $nom_fichier=$filename;
 $nom_fichier="$d"."$accession";
&cds();
&exon();
&intron();
&gene();
&gb_fasta();


$seq_object = $io->next_seq ;
if (  $seq_object!=Null){
$accession= $seq_object->accession;}
 }
else{
open(f,">>$d"."$accession");

print f $ligne;
}

}
open (IN,"<$filename") || die ("\nError: FASTA file doesn't exist !\n\n");
my $io = Bio::SeqIO->new(-file => $filename, -format => "genbank" );
 while ($seq_object = $io->next_seq){

 $accession=  $seq_object->accession;

 $nom_a=$nom_fichier;
 $nom_fichier =$accession;
 print $accession."\n";
$nom_fichier="$nom_fichier.fasta";
&simple_ssr();
print  "SSr de    " .  $accession . "\n";
$nom_fichier=$accession;
$nom_fichier="$nom_fichier.EXON.fasta";
&simple_ssr();
print  "SSr des exons de    " .  $accession . "\n";
$nom_fichier=$accession;
$nom_fichier="$nom_fichier.INTRON.fasta";
&simple_ssr();
print  "SSr des introns de    " .  $accession . "\n";
# $nom_fichier=$accession;
# $nom_fichier="$nom_fichier.GENE.fasta";
# &ssr();
print  "SSr des genes de    " .  $accession . "\n";

 }
 $filename=$nom_fichier;
}
sub all{

$filename=$nom_fichier;
$d=$nom_fichier;


open (IN,"<$d") || die ("\nError: FASTA file doesn't exist !\n\n");
my $io = Bio::SeqIO->new(-file => $filename, -format => "genbank" );
 $seq_object = $io->next_seq ;
 $accession=  $seq_object->accession;

while ($ligne = <IN>) {
if($ligne =~ /^\/\//){
close f;
open(said,"<$d"."$accession" );

$nom_fichier="$d"."$accession";
&cds();
&exon();
&intron();
&gene();

&fasta();
&gb_fasta();

close said;

$seq_object = $io->next_seq ;
if (  $seq_object!=Null){
$accession= $seq_object->accession;}
 }
else{
open(f,">>$d"."$accession");

print f $ligne;
}

}
open (IN,"<$d") || die ("\nError: FASTA file doesn't exist !\n\n");
my $io = Bio::SeqIO->new(-file => $d, -format => "genbank" );
 while ($seq_object = $io->next_seq){

 $accession=  $seq_object->accession;
 $nom_fichier=$d;
$nom_fichier="$d"."$accession.fasta";
&simple_ssr();
print  "SSr de    " .  $accession . "\n";
$nom_fichier=$d;
$nom_fichier="$d"."$accession.EXON.fasta";
&simple_ssr();
print  "SSr des exons de    " .  $accession . "\n";
$nom_fichier=$d;
$nom_fichier="$d"."$accession.INTRON.fasta";
&simple_ssr();
print  "SSr des introns de    " .  $accession . "\n";
$nom_fichier=$d;
$nom_fichier="$d"."$accession.GENE.fasta";
&ssr();
 }


}


sub simple_ssr{
$filename = $nom_fichier;
chomp($filename);

open (IN,"<$filename") || die ("\nError: FASTA file doesn't exist !\n\n");
open (OUT,">$filename.lras");
print OUT "ID\tSSR nr.\tSSR type\tSSR\tsize\tstart\tend\n";

# Reading arguments #

open (SPECS,"../lib/lras.ini") || die ("\nError: Specifications file doesn't exist !\n\n");
my %typrep;
my $amb = 0;
while (<SPECS>)
   {
   %typrep = $1 =~ /(\d+)/gi if (/^def\S*\s+(.*)/i);
   if (/^int\S*\s+(\d+)/i) {$amb = $1}
   };
my @typ = sort { $a <=> $b } keys %typrep;


#§§§§§ CORE §§§§§#

$/ = ">";
my $max_repeats = 1; #count repeats
my $min_repeats = 1000; #count repeats
my (%count_motif,%count_class); #count
my ($number_sequences,$size_sequences,%ssr_containing_seqs); #stores number and size of all sequences examined
my $ssr_in_compound = 0;
my ($id,$seq);
while (<IN>)
  {
  next unless (($id,$seq) = /(.*?)\n(.*)/s);
  my ($nr,%start,@order,%end,%motif,%repeats); # store info of all SSRs from each sequence
  $seq =~ s/[\d\s>]//g; #remove digits, spaces, line breaks,...
  $id =~ s/^\s*//g; $id =~ s/\s*$//g;$id =~ s/\s/_/g; #replace whitespace with "_"
  $number_sequences++;
  $size_sequences += length $seq;
  for ($i=0; $i < scalar(@typ); $i++) #check each motif class
    {
    my $motiflen = $typ[$i];
    my $minreps = $typrep{$typ[$i]} - 1;
    if ($min_repeats > $typrep{$typ[$i]}) {$min_repeats = $typrep{$typ[$i]}}; #count repeats
    my $search = "(([acgt]{$motiflen})\\2{$minreps,})";
    while ( $seq =~ /$search/ig ) #scan whole sequence for that class
      {
      my $motif = uc $2;
      my $redundant; #reject false type motifs [e.g. (TT)6 or (ACAC)5]
      for ($j = $motiflen - 1; $j > 0; $j--)
        {
        my $redmotif = "([ACGT]{$j})\\1{".($motiflen/$j-1)."}";
        $redundant = 1 if ( $motif =~ /$redmotif/ )
        };
      next if $redundant;
      $motif{++$nr} = $motif;
      my $ssr = uc $1;
      $repeats{$nr} = length($ssr) / $motiflen;
      $end{$nr} = pos($seq);
      $start{$nr} = $end{$nr} - length($ssr) + 1;
      # count repeats
      $count_motifs{$motif{$nr}}++; #counts occurrence of individual motifs
      $motif{$nr}->{$repeats{$nr}}++; #counts occurrence of specific SSR in its appearing repeat
      $count_class{$typ[$i]}++; #counts occurrence in each motif class
      if ($max_repeats < $repeats{$nr}) {$max_repeats = $repeats{$nr}};
      };
    };
  next if (!$nr); #no SSRs
  $ssr_containing_seqs{$nr}++;
  @order = sort { $start{$a} <=> $start{$b} } keys %start; #put SSRs in right order
  $i = 0;
  my $count_seq; #counts
  my ($start,$end,$ssrseq,$ssrtype,$size);
  while ($i < $nr)
    {
    my $space = $amb + 1;
    if (!$order[$i+1]) #last or only SSR
      {
      $count_seq++;
      my $motiflen = length ($motif{$order[$i]});
      $ssrtype = "p".$motiflen;
      $ssrseq = "($motif{$order[$i]})$repeats{$order[$i]}";
      $start = $start{$order[$i]}; $end = $end{$order[$i++]};
      next
      };
    if (($start{$order[$i+1]} - $end{$order[$i]}) > $space)
      {
      $count_seq++;
      my $motiflen = length ($motif{$order[$i]});
      $ssrtype = "p".$motiflen;
      $ssrseq = "($motif{$order[$i]})$repeats{$order[$i]}";
      $start = $start{$order[$i]}; $end = $end{$order[$i++]};
      next
      };
    my ($interssr);
    if (($start{$order[$i+1]} - $end{$order[$i]}) < 1)
      {
      $count_seq++; $ssr_in_compound++;
      $ssrtype = 'c*';
      $ssrseq = "($motif{$order[$i]})$repeats{$order[$i]}($motif{$order[$i+1]})$repeats{$order[$i+1]}*";
      $start = $start{$order[$i]}; $end = $end{$order[$i+1]}
      }
    else
      {
      $count_seq++; $ssr_in_compound++;
      $interssr = lc substr($seq,$end{$order[$i]},($start{$order[$i+1]} - $end{$order[$i]}) - 1);
      $ssrtype = 'c';
      $ssrseq = "($motif{$order[$i]})$repeats{$order[$i]}$interssr($motif{$order[$i+1]})$repeats{$order[$i+1]}";
      $start = $start{$order[$i]};  $end = $end{$order[$i+1]};
      #$space -= length $interssr
      };
    while ($order[++$i + 1] and (($start{$order[$i+1]} - $end{$order[$i]}) <= $space))
      {
      if (($start{$order[$i+1]} - $end{$order[$i]}) < 1)
        {
        $ssr_in_compound++;
        $ssrseq .= "($motif{$order[$i+1]})$repeats{$order[$i+1]}*";
        $ssrtype = 'c*';
        $end = $end{$order[$i+1]}
        }
      else
        {
        $ssr_in_compound++;
        $interssr = lc substr($seq,$end{$order[$i]},($start{$order[$i+1]} - $end{$order[$i]}) - 1);
        $ssrseq .= "$interssr($motif{$order[$i+1]})$repeats{$order[$i+1]}";
        $end = $end{$order[$i+1]};
        #$space -= length $interssr
        }
      };
    $i++;
    }
  continue
    {
    print OUT "$id\t$count_seq\t$ssrtype\t$ssrseq\t",($end - $start + 1),"\t$start\t$end\n"
    };
  };

close (OUT);
open (OUT,">$filename.statistics");

#§§§§§ INFO §§§§§#

#§§§ Specifications §§§#
print OUT "Specifications\n==============\n\nSequence source file: \"$filename\"\n\nDefinement of microsatellites (unit size / minimum number of repeats):\n";
for ($i = 0; $i < scalar (@typ); $i++) {print OUT "($typ[$i]/$typrep{$typ[$i]}) "};print OUT "\n";
if ($amb > 0) {print OUT "\nMaximal number of bases interrupting 2 SSRs in a compound microsatellite:  $amb\n"};
print OUT "\n\n\n";

#§§§ OCCURRENCE OF SSRs §§§#

#small calculations
my @ssr_containing_seqs = values %ssr_containing_seqs;
my $ssr_containing_seqs = 0;
for ($i = 0; $i < scalar (@ssr_containing_seqs); $i++) {$ssr_containing_seqs += $ssr_containing_seqs[$i]};
my @count_motifs = sort {length ($a) <=> length ($b) || $a cmp $b } keys %count_motifs;
my @count_class = sort { $a <=> $b } keys %count_class;
for ($i = 0; $i < scalar (@count_class); $i++) {$total += $count_class{$count_class[$i]}};

#§§§ Overview §§§#
print OUT "RESULTS OF MICROSATELLITE SEARCH\n================================\n\n";
print OUT "Total number of sequences examined:              $number_sequences\n";
print OUT "Total size of examined sequences (bp):           $size_sequences\n";
print OUT "Total number of identified SSRs:                 $total\n";
print OUT "Number of SSR containing sequences:              $ssr_containing_seqs\n";
print OUT "Number of sequences containing more than 1 SSR:  ",$ssr_containing_seqs - ($ssr_containing_seqs{1} || 0),"\n";
print OUT "Number of SSRs present in compound formation:    $ssr_in_compound\n\n\n";

#§§§ Frequency of SSR classes §§§#
print OUT "Distribution to different repeat type classes\n---------------------------------------------\n\n";
print OUT "Unit size\tNumber of SSRs\n";
my $total = undef;
for ($i = 0; $i < scalar (@count_class); $i++) {print OUT "$count_class[$i]\t$count_class{$count_class[$i]}\n"};
print OUT "\n";

#§§§ Frequency of SSRs: per motif and number of repeats §§§#
print OUT "Frequency of identified SSR motifs\n----------------------------------\n\nRepeats";
for ($i = $min_repeats;$i <= $max_repeats; $i++) {print OUT "\t$i"};
print OUT "\ttotal\n";
for ($i = 0; $i < scalar (@count_motifs); $i++)
  {
  my $typ = length ($count_motifs[$i]);
  print OUT $count_motifs[$i];
  for ($j = $min_repeats; $j <= $max_repeats; $j++)
    {
    if ($j < $typrep{$typ}) {print OUT "\t-";next};
    if ($count_motifs[$i]->{$j}) {print OUT "\t$count_motifs[$i]->{$j}"} else {print OUT "\t"};
    };
  print OUT "\t$count_motifs{$count_motifs[$i]}\n";
  };
print OUT "\n";

#§§§ Frequency of SSRs: summarizing redundant and reverse motifs §§§#
# Eliminates %count_motifs !
print OUT "Frequency of classified repeat types (considering sequence complementary)\n-------------------------------------------------------------------------\n\nRepeats";
my (%red_rev,@red_rev); # groups
for ($i = 0; $i < scalar (@count_motifs); $i++)
  {
  next if ($count_motifs{$count_motifs[$i]} eq 'X');
  my (%group,@group,$red_rev); # store redundant/reverse motifs
  my $reverse_motif = $actual_motif = $actual_motif_a = $count_motifs[$i];
  $reverse_motif =~ tr/ACGT/TGCA/;
  my $reverse_motif_a = $reverse_motif;
  for ($j = 0; $j < length ($count_motifs[$i]); $j++)
    {
    if ($count_motifs{$actual_motif}) {$group{$actual_motif} = "1"; $count_motifs{$actual_motif}='X'};
    if ($count_motifs{$reverse_motif}) {$group{$reverse_motif} = "1"; $count_motifs{$reverse_motif}='X'};
    $actual_motif =~ s/(.)(.*)/$2$1/;
    $reverse_motif =~ s/(.)(.*)/$2$1/;
    $actual_motif_a = $actual_motif if ($actual_motif lt $actual_motif_a);
    $reverse_motif_a = $reverse_motif if ($reverse_motif lt $reverse_motif_a)
    };
  if ($actual_motif_a lt $reverse_motif_a) {$red_rev = "$actual_motif_a/$reverse_motif_a"}
  else {$red_rev = "$reverse_motif_a/$actual_motif_a"}; # group name
  $red_rev{$red_rev}++;
  @group = keys %group;
  for ($j = 0; $j < scalar (@group); $j++)
    {
    for ($k = $min_repeats; $k <= $max_repeats; $k++)
      {
      if ($group[$j]->{$k}) {$red_rev->{"total"} += $group[$j]->{$k};$red_rev->{$k} += $group[$j]->{$k}}
      }
    }
  };
for ($i = $min_repeats; $i <= $max_repeats; $i++) {print OUT "\t$i"};
print OUT "\ttotal\n";
@red_rev = sort {length ($a) <=> length ($b) || $a cmp $b } keys %red_rev;
for ($i = 0; $i < scalar (@red_rev); $i++)
  {
  my $typ = (length ($red_rev[$i])-1)/2;
  print OUT $red_rev[$i];
  for ($j = $min_repeats; $j <= $max_repeats; $j++)
    {
    if ($j < $typrep{$typ}) {print OUT "\t-";next};
    if ($red_rev[$i]->{$j}) {print OUT "\t",$red_rev[$i]->{$j}}
    else {print OUT "\t"}
    };
  print OUT "\t",$red_rev[$i]->{"total"},"\n";
  };
  close OUT;
 }