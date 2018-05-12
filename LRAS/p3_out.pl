#!/usr/bin/perl

#===============================================================================
open(f,"<filename.tmp") || die ("\nError: Couldn't open temp file  !\n\n");;
$filename = <f>;
chomp($filename);
close f;
unlink("filename.tmp");
#===============================================================================


open (SRC,"<b.txt") || die ("\nError: Couldn't open Primer3 results file (*.p3out) !\n\n");


open (IN,"<$filename.lras") || die ("\nError: Couldn't open source file containing MISA (*.misa) results !\n\n");
open (OUT,">$filename.primer.lras") || die ("nError: Couldn't create file !\n\n");

my ($seq_names_failed,$count,$countfailed);

print OUT "ID\tSSR_nr.\tSSR_type\tSSR\tsize\tstart\tend\t";
print OUT "FORWARD_PRIMER1_(5'-3')\tTm(°C)\t%GC\tsize\tREVERSE_PRIMER1_(5'-3')\tTm(°C)\t%GC\tsize\tPRODUCT1_size_(bp)\tstart_(bp)\tend_(bp)\t";
print OUT "FORWARD_PRIMER2_(5'-3')\tTm(°C)\t%GC\tsize\tREVERSE_PRIMER2_(5'-3')\tTm(°C)\t%GC\tsize\tPRODUCT2_size_(bp)\tstart_(bp)\tend_(bp)\t";
print OUT "FORWARD_PRIMER3_(5'-3')\tTm(°C)\t%GC\tsize\tREVERSE_PRIMER3_(5'-3')\tTm(°C)\t%GC\tsize\tPRODUCT3_size_(bp)\tstart_(bp)\tend_(bp)\n";

undef $/;
my $in = <IN>;
study $in;

$/ = "=\n";

while (<SRC>)
  {
  my ($id,$ssr_nr) = (/PRIMER_SEQUENCE_ID=(\S+)_(\d+)/);

  $in =~ /($id\t$ssr_nr\t.*)\n/;
  my $misa = $1;

  /PRIMER_LEFT_SEQUENCE=(.*)/ || do {$count_failed++;print OUT "$misa\n"; next};
  my $info = "$1\t";

  /PRIMER_LEFT_TM=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_GC_PERCENT=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT=\d+,(\d+)/; $info .= "$1\t";

  /PRIMER_RIGHT_SEQUENCE=(.*)/;  $info .= "$1\t";
  /PRIMER_RIGHT_TM=(.*)/; $info .= "$1\t";
  /PRIMER_RIGHT_GC_PERCENT=(.*)/; $info .= "$1\t";
  /PRIMER_RIGHT=\d+,(\d+)/; $info .= "$1\t";

  /PRIMER_PRODUCT_SIZE=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT=(\d+),\d+/; $info .= "$1\t";
  /PRIMER_RIGHT=(\d+),\d+/; $info .= "$1\t";


  /PRIMER_LEFT_1_SEQUENCE=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_1_TM=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_GC_1_PERCENT=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_1=\d+,(\d+)/; $info .= "$1\t";

  /PRIMER_RIGHT_1_SEQUENCE=(.*)/;  $info .= "$1\t";
  /PRIMER_RIGHT_1_TM=(.*)/; $info .= "$1\t";
  /PRIMER_RIGHT_GC_1_PERCENT=(.*)/; $info .= "$1\t";
  /PRIMER_RIGHT_1=\d+,(\d+)/; $info .= "$1\t";

  /PRIMER_PRODUCT_SIZE_1=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_1=(\d+),\d+/; $info .= "$1\t";
  /PRIMER_RIGHT_1=(\d+),\d+/; $info .= "$1\t";


  /PRIMER_LEFT_2_SEQUENCE=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_2_TM=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_GC_2_PERCENT=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_2=\d+,(\d+)/; $info .= "$1\t";

  /PRIMER_RIGHT_2_SEQUENCE=(.*)/;  $info .= "$1\t";
  /PRIMER_RIGHT_2_TM=(.*)/; $info .= "$1\t";
  /PRIMER_RIGHT_GC_2_PERCENT=(.*)/; $info .= "$1\t";
  /PRIMER_RIGHT_2=\d+,(\d+)/; $info .= "$1\t";

  /PRIMER_PRODUCT_SIZE_2=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_2=(\d+),\d+/; $info .= "$1\t";
  /PRIMER_RIGHT_2=(\d+),\d+/; $info .= "$1";

  $count++;
  print OUT "$misa\t$info\n"
  };
  close SRC;
  close IN;
  close OUT;

print "\nPrimer modelling was successful for $count sequences.\n";
print "Primer modelling failed for $count_failed sequences.\n";

foreach ("b.txt")
  {
  unlink($_);
  }

foreach ("a.tmp")
  {
  unlink($_);
  }