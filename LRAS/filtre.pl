#!/usr/bin/perl


open(TMP,"<a.tmp") || die "Probl�me pour ouvrir $fichier: $!";

$a = <TMP>;
print $a;

open (F, "<$a.p3out") || die "Probl�me pour ouvrir $fichier: $!";
open (S, ">>b.txt") || die "Probl�me pour ouvrir $fichier: $!";
while (my $ligne = <F>) {
if ($ligne =~ /^SEQUENCE=/) {
# si la ligne est sous la forme 02.99.45...

print S "SEQUENCE=AAAA\n";  # Alors on l�affiche
}else{
print S $ligne;
}

}
close F;