#!/usr/bin/perl

use Tk ;

use Tk::BrowseEntry;
use Tk::LabFrame;
use Tk::Menubar;
use Tk::Balloon;
use Bio::DB::GenBank;
use Bio::DB::SwissProt;
use Bio::SeqIO;
use SOAP::Lite;
use Bio::Perl;



# Fenêtre principale

$f = MainWindow->new(-background=>'#e8e8e8');
$f->geometry('800x600');
$f->title("LRAS");
$help= $f->Balloon;
use Tk::PNG;
# changer l'icone Tk par la notre


# Menu bar

$menu=$f->Frame(-relief=>'groove',
        -borderwidth=>3,
        -background=>'#e8e8e8',)
        ->pack(-side=>'top',-fill=>'x');

# Menu Fichier

$button_fichier = $menu->Menubutton(-text=>'Fichier',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black')
        ->pack(-side=>'left');

$button_fichier -> command(-label=>'Ouvrir',
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black',
        -command=>\&Ouvrir,
        -accelerator=>'Ctrl-o');
        $button_fichier->separator;

$button_fichier -> command(-label=>'Enregistrer',
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black',
        -command=>\&Enregistrer,
        -accelerator=>'Ctrl-e');

$button_fichier -> command(-label=>'Enregistrer sous',
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black',
        -command=>\&Enregistrer_sous);
        $button_fichier->separator;

$button_fichier -> command(-label=>'Supprimer',
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black',
        -command=>\&Suprimer,
        -accelerator=>'Ctrl-s');
        $button_fichier->separator;

$button_fichier -> command(-label=>'Quitter',
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black',
        -command=>\&Quitter,
        -accelerator=>'Ctrl-q');


# Menu edition

$editmenu = $menu->Menubutton(-text => 'Edition',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black',)
        ->pack(-side=>'left');

$editmenu->command(-label => 'couper',
-activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -accelerator=>'Ctrl-X',
        -foreground=>'black',
-command => sub{
my ($w) = @_;
$t->Column_Copy_or_Cut(1);
});

$editmenu->command(-label => 'copier',
-activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -accelerator=>'Ctrl-C',
        -foreground=>'black',
-command => sub{
my ($w) = @_;
$t->Column_Copy_or_Cut(0);
 });

$editmenu->command(-label => 'coller',
-activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -accelerator=>'Ctrl-V',
        -foreground=>'black',
-command => sub{
$t->clipboardColumnPaste();
});

$editmenu->separator;

$editmenu->command(-label => 'sélectionner tout',
-activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -accelerator=>'Ctrl-A',
        -foreground=>'black',
-command => sub{
$t->selectAll();
});

# Menu SSR

$button_SSR = $menu->Menubutton(-text=>'Microsat',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black',)
        ->pack(-side=>'left');

$export1_menu = $button_SSR->command(-label => "Microsatellites",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&simple_ssr,
        -foreground=>'black');

$export1_menu = $button_SSR-> command(-label => "Amorces SSR",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&primer_ssr,
        -foreground=>'black');

# Menu extraction

$button_extraction = $menu->Menubutton(-text=>'Extraction',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black',)
        ->pack(-side=>'left');

$export1_menu = $button_extraction->command(-label => "Contigs",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&all,
        -foreground=>'black');

$export1_menu = $button_extraction->command(-label => "Gènes",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&gene,
        -foreground=>'black');

$export1_menu = $button_extraction->command(-label => "Introns",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&intron,
        -foreground=>'black');

$export1_menu = $button_extraction->command(-label => "Exons",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&exon,
        -foreground=>'black');

$export1_menu = $button_extraction->command(-label => "CDS",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&cds,
        -foreground=>'black');

$export1_menu = $button_extraction->command(-label => "Tout",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&frag_all,
        -foreground=>'black');

# Menu telecharger

$button_extraction = $menu->Menubutton(-text=>'Télécharger',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black',)
        ->pack(-side=>'left');

$export1_menu = $button_extraction->command(-label => "GenPept --> GenBank",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&genpept_genbank,
        -foreground=>'black');

$export1_menu = $button_extraction->command(-label => "GenPept --> CDS",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&GenPept_NCBI_CDS,
        -foreground=>'black');


# Menu analyse seq

$button_analyse_seq = $menu->Menubutton(-text=>'Options',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black',)
        ->pack(-side=>'left');

$export1_menu = $button_analyse_seq->command(-label => "Excel",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&excel,
        -foreground=>'black');


$export1_menu = $button_analyse_seq->command(-label => "Fragmenter",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&fragmenter,
        -foreground=>'black');

$export1_menu = $button_analyse_seq->command(-label => "Info",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&info,
        -foreground=>'black');


# Menu analyse seq





# Menu Analyser



# Menu converssion

$button_converssion = $menu->Menubutton(-text=>'Conversion',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black')
        ->pack(-side=>'left');

$export1_menu = $button_converssion->cascade(-label => "~Fasta vers...",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black');
        $button_converssion->separator;

$export2_menu = $button_converssion->cascade(-label => "~Genbank vers...",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black');
        $button_converssion->separator;

$export3_menu = $button_converssion->cascade(-label => "~Swiss vers...",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black');


    $export1_menu->command(-label => "~Genbank",
                          -background=>'#e8e8e8',
                          -activebackground=>'#8CB4E8',
                          -command =>\&converssion1);

     $export1_menu->command(-label => "~Swiss",
                          -background=>'#e8e8e8',
                          -activebackground=>'#8CB4E8',
                          -command =>\&converssion3);

    $export2_menu->command(-label => "~Fasta",
                          -background=>'#e8e8e8',
                          -activebackground=>'#8CB4E8',
                          -command =>\&converssion2);

    $export2_menu->command(-label => "~Swiss",
                          -background=>'#e8e8e8',
                          -activebackground=>'#8CB4E8',
                          -command =>\&converssion6);

    $export3_menu->command(-label => "~Fasta",
                          -background=>'#e8e8e8',
                          -activebackground=>'#8CB4E8',
                          -command =>\&converssion4);

    $export3_menu->command(-label => "~Genbank",
                          -background=>'#e8e8e8',
                          -activebackground=>'#8CB4E8',
                          -command =>\&converssion5);





# Menu analyse seq

$button_excel = $menu->Menubutton(-text=>'Blast',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black',)
        ->pack(-side=>'left');

$export1_menu = $button_excel->command(-label => "BLAST",
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&blast,
        -foreground=>'black');






# menu aide

$button_aide = $menu->Menubutton(-text=>'Aide',
        -background=>'#e8e8e8',
        -activebackground=>'#8CB4E8',
        -foreground=>'black',)
        ->pack(-side=>'left');

$button_aide -> command(-label=>'Perl',
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -foreground=>'black',
        -command=>\&perl);




# barre icon

$barre_icon = $f -> Frame(-relief => 'groove' ,
        -borderwidth => 2 ,
        -background => '#e8e8e8' )
        -> pack ( -side => 'top' , -anchor => 'n' , -expand => 1 , -fill => 'x' ) ;


my $Photo_logo =$barre_icon->Photo( -file => "adn.png" );
$f->iconimage($Photo_logo);

# icon ouvrir

$image_ouvrir = $barre_icon->Photo(-file =>"ouvrir.gif");
$ouvrir=$barre_icon->Button(-background => '#e8e8e8',
        -relief => 'flat',
        -activebackground=>'#8CB4E8',
        -command =>\&Ouvrir,
        -image => $image_ouvrir)
        ->pack(-side => 'left');

$help->attach($ouvrir, -msg => "Ouvrir..");


  #########################
$image_separe = $barre_icon->Photo(-file =>"20.gif");
$ouvrir=$barre_icon->Label(
        -image => $image_separe)
        ->pack(-side => 'left');

$help->attach($ouvrir, -msg => "Ouvrir..");
  ##############################
# icon coupeir

$image_copier = $barre_icon->Photo(-file =>"copier.gif");
$enregistrer = $barre_icon->Button(-background => '#e8e8e8',
        -relief => 'flat',
        -activebackground=>'#8CB4E8',
        -command => sub{
my ($w) = @_;
$t->Column_Copy_or_Cut(0);
 },
        -image => $image_copier)
        ->pack(-side => 'left');
$help->attach($enregistrer, -msg => "copier");

# icon coller

$image_coller = $barre_icon->Photo(-file =>"coller.gif");
$enregistrer = $barre_icon->Button(-background => '#e8e8e8',
        -relief => 'flat',
        -activebackground=>'#8CB4E8',
        -command => sub{
$t->clipboardColumnPaste();
},
        -image => $image_coller)
        ->pack(-side => 'left');
$help->attach($enregistrer, -msg => "coller");

#########################
$image_separe = $barre_icon->Photo(-file =>"20.gif");
$ouvrir=$barre_icon->Label(
        -image => $image_separe)
        ->pack(-side => 'left');

$help->attach($ouvrir, -msg => "Ouvrir..");
  ##############################
# icon enregistrer

$image_enregistrer = $barre_icon->Photo(-file =>"Enregistrer.gif");
$enregistrer = $barre_icon->Button(-background => '#e8e8e8',
        -relief => 'flat',
        -activebackground=>'#8CB4E8',
        -command =>\&Enregistrer,
        -image => $image_enregistrer)
        ->pack(-side => 'left');
$help->attach($enregistrer, -msg => "Enregistrer");

# icon enregistrer_sous

$image_enregistrer_sous = $barre_icon->Photo(-file =>"enregistrer_sous.gif");
$enregistrer_sous=$barre_icon->Button(-background => '#e8e8e8',
        -relief => 'flat',
        -activebackground=>'#8CB4E8',
        -command =>\&Enregistere_sous,
        -image => $image_enregistrer_sous)
        ->pack(-side => 'left');
$help->attach($enregistrer_sous, -msg => "Enregistere sous..");
#########################
$image_separe = $barre_icon->Photo(-file =>"20.gif");
$ouvrir=$barre_icon->Label(
        -image => $image_separe)
        ->pack(-side => 'left');

$help->attach($ouvrir, -msg => "Ouvrir..");
  ##############################

# icon suprimer

$image_suprimer = $barre_icon->Photo(-file =>"sup.gif");
$suprimer=$barre_icon->Button(-background => '#e8e8e8',
        -relief => 'flat',
        -activebackground=>'#8CB4E8',
        -command =>\&Suprimer ,
        -image => $image_suprimer)
        ->pack(-side => 'left');
 $help->attach($suprimer, -msg => "Suprimer");



# icon aide

$image_aide = $barre_icon->Photo(-file =>"aide.gif");
$m6=$barre_icon->Button(-background => '#e8e8e8',
        -relief => 'flat',
        -activebackground=>'#8CB4E8',
        -command=>\&Aide,
        -image => $image_aide)
        ->pack(-side => 'left');
$help->attach($m6, -msg => "Aide");

# icon sortir

$image_Quitter = $barre_icon->Photo(-file =>"sortir.gif");
$Quitter=$barre_icon->Button(-background => '#e8e8e8',
        -relief => 'flat',
        -activebackground=>'#8CB4E8',
        -command =>\&Quitter,
        -image => $image_Quitter)
        ->pack(-side=>"left");
$help->attach($Quitter, -msg => "Quitter");

# logo

$fram_logo= $f -> Frame(-relief => 'groove' ,
        -borderwidth => 2 ,
        -background => '#e8e8e8', )
        -> pack ( -side => 'top' , -anchor => 'n' , -expand => 1 , -fill => 'x' ) ;


# $image_logo = $fram_logo->Photo(-file =>"LRAS.gif");
# $logo=$fram_logo->Label(-background => '#e8e8e8',
#         -relief => 'flat',
#         -activebackground=>'#8CB4E8',
#         -image => $image_logo)
#         ->pack(-side => 'left');

# label bas de la page

$message1 =$f -> Label (-relief => 'groove',
        -text => 'MOJEMMI Said & RCHOK Fatiha | © 2010 LRAS',
        -foreground => 'red',
        -background => '#e8e8e8')
        ->pack(-side => 'bottom',-fill => 'x') ;





####################################################################################

# fenetres de texte


$fenetre = $f-> Frame(-relief=>'groove',
        -borderwidth=>3,
        -background=>'#e8e8e8')
        ->pack(-expand=>1,-side=>'right',-fill=>'both');

     ####################

$label_f1 =$fenetre-> Frame(-relief=>'groove',
        -background=>'#e8e8e8')
        ->pack(-expand=>1,-side=>'top',-fill=>'both');

$search_string = "";





$message1 = $label_f1 -> Label (-text => 'Entrer un motif',
        -background => '#e8e8e8' )
        ->pack(-side => 'left',-anchor => 'n') ;

$be = $label_f1->BrowseEntry(-background => 'White',
        -variable => \$search_string,
        -browsecmd => \&do_search)
        ->pack(-side => 'left',-anchor => 'n');

# Si l'utilisateur tape dans la parole et les touches de retour, invoquer do_search

$be->bind("<Return>", \&do_search);
$be->focus;  # Start w/focus on BrowseEntry

# Si vous cliquez sur le bouton Recherche invoquera do_search
$label_f1->Button(-text => 'Recherche',
        -background => '#e8e8e8',
        -relief => 'groove' ,
        -command => \&do_search)
        ->pack(-side => 'left',-anchor => 'n');

$image6 = $label_f1->Photo(-file =>"grandir.gif");
$btn_modif2 = $label_f1-> Button (-relief => 'flat',
                -background=>'#e8e8e8',
                -activebackground=>'#8CB4E8',
               -image => $image6,
               -command => \&nouvelle1 )
               -> pack ( -side => 'right') ;
$help->attach($btn_modif2, -msg => "Agrandir");

$image_separe = $label_f1->Photo(-file =>"20.gif");
$ouvrir=$label_f1->Label(
        -image => $image_separe)
        ->pack(-side => 'right');

$image4 = $label_f1->Photo(-file =>"suprimer.gif");
$suprimer_texte1=$label_f1->Button(-relief => 'flat',
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&Suprimer_f1,
        -image => $image4)
        ->pack(-side => 'right');
$help->attach($suprimer_texte1, -msg => "supprimer");

$message1 =$label_f1 -> Label (-text => '',
        -background=>'#e8e8e8')
        ->pack(-side => 'top',-fill => 'x') ;



     ####################

$t = $fenetre -> Scrolled ('Text' ,
        -scrollbars => 'se' ,
        -width => 70 ,
        -height => 50 ,
        -tabs => [ '3' ])
        -> pack ( -fill => 'x' ) ;


   ####################

# $label_f2 =$fenetre-> Frame(-relief=>'groove',
#         -background=>'#e8e8e8')
#         ->pack(-expand=>1,-side=>'top',-fill=>'both');
#
#
#
# $message1 = $label_f2 -> Label (-text => 'Entrer une motif',
#         -background => '#e8e8e8' )
#         ->pack(-side => 'left',-anchor => 'n') ;
#
# $be2 = $label_f2->BrowseEntry(-background => 'White',
#         -variable => \$search_string2,
#         -browsecmd => \&do_search_t2)
#         ->pack(-side => 'left',-anchor => 'n');
#
# # Si l'utilisateur tape dans la parole et les touches de retour, invoquer do_search
#
# $be2->bind("<Return>", \&do_search);
# $be2->focus;  # Start w/focus on BrowseEntry
#
# # Si vous cliquez sur le bouton Recherche invoquera do_search
# $label_f2->Button(-text => 'Recherche',
#         -background => '#e8e8e8',
#         -relief => 'groove' ,
#         -command => \&do_search_t2)
#         ->pack(-side => 'left',-anchor => 'n');
# $image6 = $label_f2->Photo(-file =>"grandir.gif");
# $btn_modif2 = $label_f2-> Button (-relief => 'flat',
#                 -background=>'#e8e8e8',
#                 -activebackground=>'#8CB4E8',
#                -image => $image6,
#                -command => \&nouvelle2 )
#                -> pack ( -side => 'right') ;
# $help->attach($btn_modif2, -msg => "Agrandir");
#
# $image_separe = $label_f2->Photo(-file =>"20.gif");
# $ouvrir=$label_f2->Label(
#         -image => $image_separe)
#         ->pack(-side => 'right');
#
# $image4 = $label_f2->Photo(-file =>"suprimer.gif");
# $suprimer_texte1=$label_f2->Button(-relief => 'flat',
#         -activebackground=>'#8CB4E8',
#         -background=>'#e8e8e8',
#         -command=>\&Suprimer_f2,
#         -image => $image4)
#         ->pack(-side => 'right');
#
#
# $help->attach($suprimer_texte1, -msg => "suprimer");
#
# $message1 =$label_f2 -> Label (-text => 'fenêtre 2',
#         -background=>'#e8e8e8' )
#         ->pack(-side => 'top',-fill => 'x') ;

   ####################

# $t2 = $fenetre -> Scrolled ('Text' ,
#        -scrollbars => 'se' ,
#        -width => 70 ,
#        -height => 25 ,
#        -tabs => [ '3' ] )
#        -> pack (-fill => 'x' ) ;
          ##############



           #  option                     #
############################################

$boutton1 = $f -> LabFrame (
-label=>'Rcherche par ID',
-background=>'#e8e8e8',
-foreground => 'Blue',
-labelside=>'acrosstop',
-relief => 'groove' ,
-borderwidth => 2 )
-> pack ( -side => 'top' , -anchor => 'w' , -expand => 1 , -fill => 'x' ) ;

#################
$boutton3 = $boutton1 -> LabFrame (
-label=>'GenBank',
-background=>'#e8e8e8',
-foreground => 'Blue',
-labelside=>'acrosstop',
-relief => 'groove' ,
-borderwidth => 2 )
-> pack ( -side => 'top' , -anchor => 'w' , -expand => 1 , -fill => 'x' ) ;

$message1 = $boutton3 -> Label (
-text => 'Entrez l\'ID GenBank',
-background=>'#e8e8e8',   )
-> pack (-side => 'left',-anchor => 'w' ) ;

$btn_modif = $boutton3 -> Button (
-text => 'Valider' ,
-background=>'#e8e8e8',
-relief => 'groove' ,
-command => \&salut )
-> pack ( -side => 'right',-anchor => 'w' ) ;

$zone_saisie2 = $boutton3 -> Entry ( )
->pack(-side=>'right') ;

#***********
$boutton2 = $boutton1 -> LabFrame (
-label=>'SwissProt',
-background=>'#e8e8e8',
-foreground => 'Blue',
-labelside=>'acrosstop',
-relief => 'groove' ,
-borderwidth => 2 )
-> pack ( -side => 'top' , -anchor => 'w' , -expand => 1 , -fill => 'x' ) ;


$message01 = $boutton2 -> Label (
-background=>'#e8e8e8',
-text => 'Entrez l\'ID Swiss-Prot' )
-> pack (-side => 'left',-anchor => 'w' ) ;

$btn_modif0 = $boutton2 -> Button (
-background=>'#e8e8e8',
-text => 'Valider' ,
-relief => 'groove' ,
-command => \&swissprot )
-> pack ( -side => 'right',-anchor => 'w' ) ;

$zone_saisie02 = $boutton2 -> Entry ( )
->pack(-side=>'right') ;



$boutton4 = $f -> LabFrame (
-label=>'Rcherche par mot clés',
-background=>'#e8e8e8',
-foreground => 'Blue',
-labelside=>'acrosstop',
-relief => 'groove' ,
-borderwidth => 2 )
-> pack ( -side => 'top' , -anchor => 'w' , -expand => 1 , -fill => 'x' ) ;

$message01 = $boutton4 -> Label (
-background=>'#e8e8e8',
-text => 'Recherche' )
-> pack (-side => 'left',-anchor => 'w' ) ;

$btn_modif0 = $boutton4 -> Button (
-background=>'#e8e8e8',
-text => 'Valider' ,
-relief => 'groove' ,
-command => \&mot_cle )
-> pack ( -side => 'right',-anchor => 'w' ) ;

$zone_saisie02 = $boutton4 -> Entry ( )
->pack(-side=>'right') ;



#########################################################################################################







###########











$boutton00 = $f -> LabFrame (
-background=>'#e8e8e8',
-label=>'',
-labelside=>'acrosstop',
-relief => 'groove' ,
-borderwidth => 2 )

-> pack ( -side => 'top' , -anchor => 'w' , -expand => 1 , -fill => 'x' ) ;

#
# fenetres de texte


$fenetre = $boutton00-> Frame(-relief=>'groove',
        -borderwidth=>3,
        -background=>'#e8e8e8')
        ->pack(-expand=>1,-side=>'top',-fill=>'both');

     ####################

$label_f1 =$fenetre-> Frame(-relief=>'groove',
        -background=>'#e8e8e8')
        ->pack(-expand=>1,-side=>'top',-fill=>'both');

$search_string = "";





$message1 = $label_f1 -> Label (-text => 'Entrer un motif',
        -background => '#e8e8e8' )
        ->pack(-side => 'left',-anchor => 'n') ;

$be = $label_f1->BrowseEntry(-background => 'White',
        -variable => \$search_string,
        -browsecmd => \&do_search)
        ->pack(-side => 'left',-anchor => 'n');

# Si l'utilisateur tape dans la parole et les touches de retour, invoquer do_search

$be->bind("<Return>", \&do_search);
$be->focus;  # Start w/focus on BrowseEntry

# Si vous cliquez sur le bouton Recherche invoquera do_search
$label_f1->Button(-text => 'Recherche',
        -background => '#e8e8e8',
        -relief => 'groove' ,
        -command => \&do_search)
        ->pack(-side => 'left',-anchor => 'n');

$image6 = $label_f1->Photo(-file =>"grandir.gif");
$btn_modif2 = $label_f1-> Button (-relief => 'flat',
                -background=>'#e8e8e8',
                -activebackground=>'#8CB4E8',
               -image => $image6,
               -command => \&nouvelle2 )
               -> pack ( -side => 'right') ;
$help->attach($btn_modif2, -msg => "Agrandir");

$image_separe = $label_f1->Photo(-file =>"20.gif");
$ouvrir=$label_f1->Label(
        -image => $image_separe)
        ->pack(-side => 'right');

$image4 = $label_f1->Photo(-file =>"suprimer.gif");
$suprimer_texte1=$label_f1->Button(-relief => 'flat',
        -activebackground=>'#8CB4E8',
        -background=>'#e8e8e8',
        -command=>\&Suprimer_f1,
        -image => $image4)
        ->pack(-side => 'right');
$help->attach($suprimer_texte1, -msg => "suprimer");

$message1 =$label_f1 -> Label (-text => '',
        -background=>'#e8e8e8')
        ->pack(-side => 'top',-fill => 'x') ;


$t3 = $boutton00 -> Scrolled (

'Text' ,
-background => 'BLACK',
-foreground => 'green',
-scrollbars => 'se' ,
-width => 70 , -height => 400 , -tabs => [ '3' ]
                    )

-> pack ( -fill => 'x' ) ;




## key binding
$f -> bind('<Control-o>' => \&Ouvrir);
$f -> bind('<Control-e>' => \&Enregistrer);
$f -> bind('<Control-s>' => \&Suprimer);
$f -> bind('<Control-q>' => \&Quitter);





MainLoop();

## fonction

sub Ouvrir{
        $nom_fichier = $f -> getOpenFile ( -initialdir => 'c:\\' );
        $nom_fichier =~ tr/\//\\/;
        open (f,$nom_fichier);
        @a=<f>;
        close f;
        $adn=@a;
        $adn=join("",@a);
        $adn=~ tr/atcg/ATCG/;
        $t -> insert ( 'end' , "$adn" ) ;
 }

  sub Enregistrer {
        my $outfile = $f->getSaveFile(-title=>'Enregistrer');
        $aa=$outfile;
        open(OUTFILE,">$outfile") or die "Can't open output file $outfile\n";
        print OUTFILE $t2->get("1.0","end");
        close OUTFILE;
        $f->messageBox(-title => 'terminer',
                    -message => 'Résultats enregistrés',
                    -type => 'OK');
}


 sub Enregistrer_sous {
       if( open(OUTFILE,">$aa")){
       print OUTFILE $t2->get("1.0","end");
       close OUTFILE;
       $f->messageBox(-title => 'Finished',
                    -message => 'Résultats enregistrés',
                    -type => 'OK');
       }else{ my $outfile = $f->getSaveFile(-title=>'Enregistrer sous');
       $aa=$outfile;
       open(OUTFILE,">$outfile") or die "\n";
       print OUTFILE $t2->get("1.0","end");
       close OUTFILE;
       $f->messageBox(-title => 'terminer',
                    -message => 'Résultats enregistrés',
                    -type => 'OK');
                    }
}



 sub Suprimer{
      $t->configure(-state=>'normal');
      $t->delete('1.0','end');
      $t2->configure(-state=>'normal');
      $t2->delete('1.0','end');
}

sub  Suprimer_f1{
      $t->configure(-state=>'normal');
      $t->delete('1.0','end');
}

  sub  Suprimer_f2{
      $t2->configure(-state=>'normal');
      $t2->delete('1.0','end');
}

sub Quitter {
      exit ( 0 ) ;
}



sub do_search {
  # Chaîne de recherche Ajouter à la liste si elle n'est pas déjà là
       if (! exists $searches{$search_string}) {
       $be->insert('end', $search_string);
       }
       $searches{$search_string}++;

 # Calculer où une recherche à partir, et ce pour mettre en évidence prochaine
       my $startindex = 'insert';
       if (defined $t->tagRanges('curSel')) {
       $startindex = 'curSel.first + 1 chars';
       }
       my $index = $t->search('-nocase', $search_string, $startindex);
       if ($index ne '') {
       $t->tagRemove('curSel', '1.0', 'end');
       my $endindex = "$index + " .  (length $search_string) . " chars";
       $t->tagAdd('curSel', $index, $endindex);
       $t->see($index);
       }else { $mw->bell; }

       $be->selectionRange(0, 'end');

       $t->tagConfigure('curSel', -background => $t->cget(-selectbackground),
                  -borderwidth => $t->cget(-selectborderwidth),
                  -foreground => $t->cget(-selectforeground));
}

sub do_search_t2 {
  # Chaîne de recherche Ajouter à la liste si elle n'est pas déjà là
       if (! exists $searches{$search_string2}) {
       $be2->insert('end', $search_string2);
       }
       $searches{$search_string2}++;

 # Calculer où une recherche à partir, et ce pour mettre en évidence prochaine
       my $startindex = 'insert';
       if (defined $t2->tagRanges('curSel')) {
       $startindex = 'curSel.first + 1 chars';
       }
       my $index = $t2->search('-nocase', $search_string2, $startindex);
       if ($index ne '') {
       $t2->tagRemove('curSel', '1.0', 'end');
       my $endindex = "$index + " .  (length $search_string2) . " chars";
       $t2->tagAdd('curSel', $index, $endindex);
       $t2->see($index);
       }else { $mw->bell; }

       $be2->selectionRange(0, 'end');

       $t2->tagConfigure('curSel', -background => $t2->cget(-selectbackground),
                  -borderwidth => $t2->cget(-selectborderwidth),
                  -foreground => $t2->cget(-selectforeground));
}


sub o{
  $nom_fichier = $f -> getOpenFile ( -initialdir => 'c:\\' );
 }

 sub s {

# fix portability

$outfile = $f->getSaveFile(-title=>'Save Results As');
    open(OUTFILE,">$outfile") or die "Can't open output file $outfile\n";
    close OUTFILE;

}


sub simple_ssr{
&time();
$filename = $nom_fichier;
chomp($filename);

open (IN,"<$filename") || die ("\nError: FASTA file doesn't exist !\n\n");
open (OUT,">$filename.lras");
print OUT "ID\tSSR nr.\tSSR type\tSSR\tsize\tstart\tend\n";

# Reading arguments #

open (SPECS,"lras.ini") || die ("\nError: Specifications file doesn't exist !\n\n");
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
  &time();
  $t3->insert("end", "L'exécution est terminée: 2 fichiers générés:  .lras & .statistics\n" );
 }

sub primer_ssr{
   &time();
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
open (SPECS,"lras.ini") || die ("\nError: Specifications file doesn't exist !\n\n");
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
$t3->insert("end", "la paire d'amorce N° : $a\n" );
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
    &time();
    $t3->insert("end", "L'exécution est terminée: 1 fichier généré:  .primers.lras\n" );
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


sub all{
 &time();
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
# &cds();
# &exon();
# &intron();
# &gene();
#
# &fasta();
# &gb_fasta();

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

 &time();
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

sub frag_all{
 &time();
&cds();
$t3->insert("end", "Le fichie  $nom_fichier\.CDS est généré.\n" );
&exon();
$t3->insert("end", "Le fichie  $nom_fichier\.EXON est généré.\n" );
&intron();
$t3->insert("end", "Le fichie  $nom_fichier\.INTRON est généré.\n" );
&gene();
 &time();

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

sub genpept_genbank{
&time();
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
&time();
}

sub GenPept_NCBI_CDS{
 &time();
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
 &time();
}

sub info {
&time();
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
$t3 -> insert ( 'end' , "nobre de lignes     : $nub_ligne\n" ) ;
$t3 -> insert ( 'end' , "nobre de sequences  : $nub_seq\n" ) ;
&time();
}

sub fragmenter{
 &time();
$filename = $nom_fichier;
open (IN,"<$filename") || die ("\nError: FASTA file doesn't exist !\n\n");
$a=0;
while (my $ligne = <IN>) {
if(($ligne =~ /^\>/)){
#mkdir("../input/frag/");
$a++;
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
&time();
}

sub excel{
&time();
$filename=$nom_fichier;
open(SRC,"<$filename")|| die ("\nError: temp/filename.tmp file doesn't exist !\n\n");
open(CSV,">>$filename.csv")|| die ("\nError: temp/filename.tmp file doesn't exist !\n\n");
while($ligne=<SRC>){
$ligne=~ s/\s/;/g;
print CSV "$ligne"."\n";

}
close SRC ;
close CSV ;
&time();
$t3->insert("end", "Le fichie  Excel est créé.\n" );
}

sub blast{

$seqio  = Bio::SeqIO->new( '-format' => 'FASTA' , -file => "$nom_fichier");

      while ( $seqobj = $seqio->next_seq() ) {
       $blast_result = blast_sequence($seqobj);

       write_blast(">>$nom_fichier.blast",$blast_result);


    }
    }


sub mot_cle{
$nom=$zone_saisie02 -> get ( ) ;

print $nom;
my $gb = new Bio::DB::GenBank;
my $query = Bio::DB::Query::GenBank->new
(-query   =>'$nom',
 -db      => 'nucleotide');
 my $seqio = $gb->get_Stream_by_query($query);
 while( my $seq =  $seqio->next_seq ) {
 $a=$seq->desc();
 $t3->insert("end", "$a\n" );

}
}

sub time{
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $s = "$sec\t";
print "seconde: ",$s,"\n";

my $m = "$min\t";
print "minute: ",$m,"\n";

my $h = "$hour\t";
print "heure: ",$h,"\n";
}


sub convirtir1{


$in  = Bio::SeqIO->new(-file => "$nom_fichier" , '-format' => 'Fasta');
$out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'Genbank');

while ( $seq = $in->next_seq() )
{
   $out->write_seq($seq);
}
 open (f,$nom_fichier);
        @aa=<f>;
        close f;
        $adn12=@aa;
        $adn12=join("",@aa);
        $t4 -> insert ( 'end' , "$adn12\n" ) ;

 open (f,$outfile);
        @aaa=<f>;
        close f;
        $adn122=@aaa;
        $adn122=join("",@aaa);
        $t5 -> insert ( 'end' , "$adn122\n" ) ;
}

sub convirtir2{

&time();
$in  = Bio::SeqIO->new(-file => "$nom_fichier" , '-format' => 'Genbank');
$out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'Fasta');

while ( $seq = $in->next_seq() )
{
 $out->write_seq($seq);
}
open (f,$nom_fichier);
        @aa=<f>;
        close f;
        $adn12=@aa;
        $adn12=join("",@aa);
        $t4 -> insert ( 'end' , "$adn12\n" ) ;

 open (f,$outfile);
        @aaa=<f>;
        close f;
        $adn122=@aaa;
        $adn122=join("",@aaa);
        $t5 -> insert ( 'end' , "$adn122\n" ) ;
&time();
}

sub convirtir3{


$in  = Bio::SeqIO->new(-file => "$nom_fichier" , '-format' => 'Fasta');
$out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'swiss');

while ( $seq = $in->next_seq() )
{
   $out->write_seq($seq);
}
open (f,$nom_fichier);
        @aa=<f>;
        close f;
        $adn12=@aa;
        $adn12=join("",@aa);
        $t4 -> insert ( 'end' , "$adn12\n" ) ;

 open (f,$outfile);
        @aaa=<f>;
        close f;
        $adn122=@aaa;
        $adn122=join("",@aaa);
        $t5 -> insert ( 'end' , "$adn122\n" ) ;
}

sub convirtir4{


$in  = Bio::SeqIO->new(-file => "$nom_fichier" , '-format' => 'swiss');
$out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'Fasta');

while ( $seq = $in->next_seq() )
{
   $out->write_seq($seq);
}
open (f,$nom_fichier);
        @aa=<f>;
        close f;
        $adn12=@aa;
        $adn12=join("",@aa);
        $t4 -> insert ( 'end' , "$adn12\n" ) ;

 open (f,$outfile);
        @aaa=<f>;
        close f;
        $adn122=@aaa;
        $adn122=join("",@aaa);
        $t5 -> insert ( 'end' , "$adn122\n" ) ;
}

sub convirtir5{


$in  = Bio::SeqIO->new(-file => "$nom_fichier" , '-format' => 'swiss');
$out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'Genbank');

while ( $seq = $in->next_seq() )
{
   $out->write_seq($seq);
}
open (f,$nom_fichier);
        @aa=<f>;
        close f;
        $adn12=@aa;
        $adn12=join("",@aa);
        $t4 -> insert ( 'end' , "$adn12\n" ) ;

 open (f,$outfile);
        @aaa=<f>;
        close f;
        $adn122=@aaa;
        $adn122=join("",@aaa);
        $t5 -> insert ( 'end' , "$adn122\n" ) ;
}

sub convirtir6{


$in  = Bio::SeqIO->new(-file => "$nom_fichier" , '-format' => 'Genbank');
$out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'Fasta');

while ( $seq = $in->next_seq() )
{
   $out->write_seq($seq);
}
open (f,$nom_fichier);
        @aa=<f>;
        close f;
        $adn12=@aa;
        $adn12=join("",@aa);
        $t4 -> insert ( 'end' , "$adn12\n" ) ;

 open (f,$outfile);
        @aaa=<f>;
        close f;
        $adn122=@aaa;
        $adn122=join("",@aaa);
        $t5 -> insert ( 'end' , "$adn122\n" ) ;
}

sub converssion1{
my $top = $f -> Toplevel(-title=>'bioinfo');
 $top->geometry('600x500');

$b = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$seqfile_label = $b->Label(-text=>'entere le nom de fichier à convertir: ')
                   ->pack(-side=>'top') ;

 $t4 = $b -> Scrolled (
                 'Text' ,
                 -background => 'BLACK',
                 -foreground => 'green',
                 -scrollbars => 'se' ,
                 -width => 80 , -height => 12 , -tabs => [ '3' ])
                 -> pack ( -fill => 'x' ) ;

$seqfile_label = $b->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;

$zone_saisie02 = $b -> Entry (
                -textvariable=> \$nom_fichier, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b-> Button (
                -relief => 'groove' ,
                -text => 'parcourir' , -command => \&o )
                -> pack ( -side => 'left',-anchor => 'w' ) ;


$b1 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$t5 = $b1 -> Scrolled (

                'Text' ,
                -background => 'BLACK',
                -foreground => 'green',
                -scrollbars => 'se' ,
                -width => 80 , -height => 12 , -tabs => [ '3' ])
                -> pack ( -fill => 'x' ) ;

$seqfile_label1 = $b1->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;
$outfile="aza";
$zone_saisie02 = $b1 -> Entry (
                -textvariable=> \$outfile, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b1-> Button (
               -relief => 'groove' ,
               -text => 'parcourir' ,
               -command => \&s )
               -> pack ( -side => 'left',-anchor => 'w' ) ;

$b3 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'bottom',-fill => 'x') ;

$btn_modif2 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'convertir' ,
               -command => \&convirtir1 )
               -> pack ( -side => 'left' ) ;

$btn_modif3 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'voir' ,
               -command => \&makeTop )
               -> pack ( -side => 'right' ) ;
  }


sub converssion3{
my $top = $f -> Toplevel(-title=>'bioinfo');
 $top->geometry('600x500');

$b = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$seqfile_label = $b->Label(-text=>'entere le nom de fichier à convertir: ')
                   ->pack(-side=>'top') ;

 $t4 = $b -> Scrolled (
                 'Text' ,
                 -background => 'BLACK',
                 -foreground => 'green',
                 -scrollbars => 'se' ,
                 -width => 80 , -height => 12 , -tabs => [ '3' ])
                 -> pack ( -fill => 'x' ) ;

$seqfile_label = $b->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;

$zone_saisie02 = $b -> Entry (
                -textvariable=> \$nom_fichier, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b-> Button (
                -relief => 'groove' ,
                -text => 'parcourir' , -command => \&o )
                -> pack ( -side => 'left',-anchor => 'w' ) ;


$b1 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$t5 = $b1 -> Scrolled (

                'Text' ,
                -background => 'BLACK',
                -foreground => 'green',
                -scrollbars => 'se' ,
                -width => 80 , -height => 12 , -tabs => [ '3' ])
                -> pack ( -fill => 'x' ) ;

$seqfile_label1 = $b1->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;
$outfile="aza";
$zone_saisie02 = $b1 -> Entry (
                -textvariable=> \$outfile, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b1-> Button (
               -relief => 'groove' ,
               -text => 'parcourir' ,
               -command => \&s )
               -> pack ( -side => 'left',-anchor => 'w' ) ;

$b3 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'bottom',-fill => 'x') ;

$btn_modif2 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'convertir' ,
               -command => \&convirtir3 )
               -> pack ( -side => 'left' ) ;

$btn_modif3 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'voir' ,
               -command => \&makeTop )
               -> pack ( -side => 'right' ) ;
               }

 sub makeTop {
 my $top = $f -> Toplevel(-title => "lras");
 $top->geometry('1000x750');
 $t4 = $top -> Scrolled (

'Text' ,
-background => 'BLACK',
-foreground => 'green',
-scrollbars => 'se' ,
-width => 80 , -height => 20 , -tabs => [ '3' ]
                    )

-> pack ( -fill => 'x' ) ;



        open (f,$nom_fichier);
        @aa=<f>;
        close f;
        $adn12=@aa;
        $adn12=join("",@aa);
        $t4 -> insert ( 'end' , "$adn12\n" ) ;

 $t4 -> insert('end', "");


$t5 = $top -> Scrolled (

'Text' ,
-background => 'BLACK',
-foreground => 'green',
-scrollbars => 'se' ,
-width => 80 , -height => 25 , -tabs => [ '3' ])
-> pack ( -fill => 'x' ) ;

open (f,$outfile);
        @aaa=<f>;
        close f;
        $adn122=@aaa;
        $adn122=join("",@aaa);
        $t5 -> insert ( 'end' , "$adn122\n" ) ;
     }

sub nouvelle2{
 my $top = $f -> Toplevel(-title => "lras");
 $top->geometry('600x600');
 $t8 = $top -> Scrolled (

'Text' ,
-scrollbars => 'se' ,
-width => 100 , -height => 100 , -tabs => [ '3' ]
                    )

-> pack ( -fill => 'x' ) ;
$a8 = $t3->get('1.0','end');
$t8 -> insert ( 'end' , "$a8" ) ;
}

sub nouvelle1{
 my $top = $f -> Toplevel(-title => "lras"); #Make the window
 $top->geometry('600x600');
 $t7 = $top -> Scrolled (

'Text' ,
-scrollbars => 'se' ,
-width => 100 , -height => 100 , -tabs => [ '3' ]
                    )

-> pack ( -fill => 'x' ) ;
$a7 = $t->get('1.0','end');
$t7 -> insert ( 'end' , "$a7" ) ;
}


sub converssion2{
my $top = $f -> Toplevel(-title=>'bioinfo');
 $top->geometry('600x500');

$b = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$seqfile_label = $b->Label(-text=>'entere le nom de fichier à convertir: ')
                   ->pack(-side=>'top') ;

 $t4 = $b -> Scrolled (
                 'Text' ,
                 -background => 'BLACK',
                 -foreground => 'green',
                 -scrollbars => 'se' ,
                 -width => 80 , -height => 12 , -tabs => [ '3' ])
                 -> pack ( -fill => 'x' ) ;

$seqfile_label = $b->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;

$zone_saisie02 = $b -> Entry (
                -textvariable=> \$nom_fichier, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b-> Button (
                -relief => 'groove' ,
                -text => 'parcourir' , -command => \&o )
                -> pack ( -side => 'left',-anchor => 'w' ) ;


$b1 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$t5 = $b1 -> Scrolled (

                'Text' ,
                -background => 'BLACK',
                -foreground => 'green',
                -scrollbars => 'se' ,
                -width => 80 , -height => 12 , -tabs => [ '3' ])
                -> pack ( -fill => 'x' ) ;

$seqfile_label1 = $b1->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;
$outfile="aza";
$zone_saisie02 = $b1 -> Entry (
                -textvariable=> \$outfile, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b1-> Button (
               -relief => 'groove' ,
               -text => 'parcourir' ,
               -command => \&s )
               -> pack ( -side => 'left',-anchor => 'w' ) ;

$b3 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'bottom',-fill => 'x') ;

$btn_modif2 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'convertir' ,
               -command => \&convirtir2 )
               -> pack ( -side => 'left' ) ;

$btn_modif3 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'voir' ,
               -command => \&makeTop )
               -> pack ( -side => 'right' ) ;
               }

sub converssion6{
my $top = $f -> Toplevel(-title=>'bioinfo');
 $top->geometry('600x500');

$b = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$seqfile_label = $b->Label(-text=>'entere le nom de fichier à convertir: ')
                   ->pack(-side=>'top') ;

 $t4 = $b -> Scrolled (
                 'Text' ,
                 -background => 'BLACK',
                 -foreground => 'green',
                 -scrollbars => 'se' ,
                 -width => 80 , -height => 12 , -tabs => [ '3' ])
                 -> pack ( -fill => 'x' ) ;

$seqfile_label = $b->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;

$zone_saisie02 = $b -> Entry (
                -textvariable=> \$nom_fichier, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b-> Button (
                -relief => 'groove' ,
                -text => 'parcourir' , -command => \&o )
                -> pack ( -side => 'left',-anchor => 'w' ) ;


$b1 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$t5 = $b1 -> Scrolled (

                'Text' ,
                -background => 'BLACK',
                -foreground => 'green',
                -scrollbars => 'se' ,
                -width => 80 , -height => 12 , -tabs => [ '3' ])
                -> pack ( -fill => 'x' ) ;

$seqfile_label1 = $b1->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;
$outfile="aza";
$zone_saisie02 = $b1 -> Entry (
                -textvariable=> \$outfile, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b1-> Button (
               -relief => 'groove' ,
               -text => 'parcourir' ,
               -command => \&s )
               -> pack ( -side => 'left',-anchor => 'w' ) ;

$b3 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'bottom',-fill => 'x') ;

$btn_modif2 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'convertir' ,
               -command => \&convirtir6 )
               -> pack ( -side => 'left' ) ;

$btn_modif3 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'voir' ,
               -command => \&makeTop )
               -> pack ( -side => 'right' ) ;
               }

sub converssion4{
my $top = $f -> Toplevel(-title=>'bioinfo');
 $top->geometry('600x500');

$b = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$seqfile_label = $b->Label(-text=>'entere le nom de fichier à convertir: ')
                   ->pack(-side=>'top') ;

 $t4 = $b -> Scrolled (
                 'Text' ,
                 -background => 'BLACK',
                 -foreground => 'green',
                 -scrollbars => 'se' ,
                 -width => 80 , -height => 12 , -tabs => [ '3' ])
                 -> pack ( -fill => 'x' ) ;

$seqfile_label = $b->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;

$zone_saisie02 = $b -> Entry (
                -textvariable=> \$nom_fichier, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b-> Button (
                -relief => 'groove' ,
                -text => 'parcourir' , -command => \&o )
                -> pack ( -side => 'left',-anchor => 'w' ) ;


$b1 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$t5 = $b1 -> Scrolled (

                'Text' ,
                -background => 'BLACK',
                -foreground => 'green',
                -scrollbars => 'se' ,
                -width => 80 , -height => 12 , -tabs => [ '3' ])
                -> pack ( -fill => 'x' ) ;

$seqfile_label1 = $b1->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;
$outfile="aza";
$zone_saisie02 = $b1 -> Entry (
                -textvariable=> \$outfile, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b1-> Button (
               -relief => 'groove' ,
               -text => 'parcourir' ,
               -command => \&s )
               -> pack ( -side => 'left',-anchor => 'w' ) ;

$b3 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'bottom',-fill => 'x') ;

$btn_modif2 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'convertir' ,
               -command => \&convirtir4 )
               -> pack ( -side => 'left' ) ;

$btn_modif3 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'voir' ,
               -command => \&makeTop )
               -> pack ( -side => 'right' ) ;
               }

sub converssion5{
my $top = $f -> Toplevel(-title=>'bioinfo');
 $top->geometry('600x500');

$b = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$seqfile_label = $b->Label(-text=>'entere le nom de fichier à convertir: ')
                   ->pack(-side=>'top') ;

 $t4 = $b -> Scrolled (
                 'Text' ,
                 -background => 'BLACK',
                 -foreground => 'green',
                 -scrollbars => 'se' ,
                 -width => 80 , -height => 12 , -tabs => [ '3' ])
                 -> pack ( -fill => 'x' ) ;

$seqfile_label = $b->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;

$zone_saisie02 = $b -> Entry (
                -textvariable=> \$nom_fichier, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b-> Button (
                -relief => 'groove' ,
                -text => 'parcourir' , -command => \&o )
                -> pack ( -side => 'left',-anchor => 'w' ) ;


$b1 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'top',-fill => 'x') ;

$t5 = $b1 -> Scrolled (

                'Text' ,
                -background => 'BLACK',
                -foreground => 'green',
                -scrollbars => 'se' ,
                -width => 80 , -height => 12 , -tabs => [ '3' ])
                -> pack ( -fill => 'x' ) ;

$seqfile_label1 = $b1->Label(
                -text=>'entere le nom de fichier à convertir: ')
                ->pack(-side=>'left') ;
$outfile="aza";
$zone_saisie02 = $b1 -> Entry (
                -textvariable=> \$outfile, )
                ->pack(-side=>'left') ;

$btn_modif1 = $b1-> Button (
               -relief => 'groove' ,
               -text => 'parcourir' ,
               -command => \&s )
               -> pack ( -side => 'left',-anchor => 'w' ) ;

$b3 = $top -> Frame(
                 -relief => 'groove' ,
                 -borderwidth => 2 , )
                 -> pack (-side=>'bottom',-fill => 'x') ;

$btn_modif2 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'convertir' ,
               -command => \&convirtir5 )
               -> pack ( -side => 'left' ) ;

$btn_modif3 = $b3-> Button (
               -relief => 'groove' ,
               -text => 'voir' ,
               -command => \&makeTop )
               -> pack ( -side => 'right' ) ;
               }




sub Affichier {
 $adn1 = $t->get('1.0','end');
 $adn=$adn1;
   @adn=$adn;
   $adn=join("",@adn);
   $adn=~ s/\s//g;
   @adn=split("",$adn);
   $nbr_A=0;
   $nbr_T=0;
   $nbr_C=0;
   $nbr_G=0;
   foreach $base( @adn)
   {
     if(($base eq "a")or($base eq "A" )){
         $nbr_A++;
         }
     elsif(($base eq "t")or($base eq "T" )){
         $nbr_T++;
         }
     elsif(($base eq "c")or($base eq "C" )){
         $nbr_C++;
         }
     elsif(($base eq "g")or($base eq "G" )){
         $nbr_G++;
         }else{

         }
   }
 $t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
 $t2->insert("end", "                         nombre de nucléotides \n" );
  $t2->insert("end","~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
  $t2 -> insert ( 'end' , "  A(Adénine)  : $nbr_A base\n" ) ;
  $t2 -> insert ( 'end' , "  T(Thymine)  : $nbr_T base\n" ) ;
  $t2 -> insert ( 'end' , "  C(Cytisine) : $nbr_C base\n" ) ;
  $t2 -> insert ( 'end' , "  G(Guanine)  : $nbr_G base\n" ) ;
  $t2->insert("end","~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
  }
sub pur{
$adn1 = $t->get('1.0','end');
 $adn=$adn1;
   @adn=$adn;
   $adn=join("",@adn);
   $adn=~ s/\s//g;
   @adn=split("",$adn);
   $nbr_A=0;
   $nbr_T=0;
   $nbr_C=0;
   $nbr_G=0;
   foreach $base( @adn)
   {
     if(($base eq "a")or($base eq "A" )){
         $nbr_A++;
         }
     elsif(($base eq "t")or($base eq "T" )){
         $nbr_T++;
         }
     elsif(($base eq "c")or($base eq "C" )){
         $nbr_C++;
         }
     elsif(($base eq "g")or($base eq "G" )){
         $nbr_G++;
         }else{

         }
   }
   $cptPur = $nbr_A + $nbr_G;
  $cptPyr = $nbr_C + $nbr_T;
 $t3->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
 $t3->insert("end", "                   nombre de purines et pyrimidines\n" );
 $t3->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
 $t3 -> insert ( 'end' , "  purinnes(CT)     : $cptPur\n" ) ;
 $t3 -> insert ( 'end' , "  pyrimidines(AG)  : $cptPyr\n" ) ;
 $t3->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );

}
  sub Transcription
 {
   my ( $texte ) ;
   $texte1=arn($p);
   $texte=substr($texte1,13);
   $texte=~ tr/atcg/ATCG/;
   $texte=~ s/T/U/g;
   $t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
   $t2->insert("end", "                        Séquence d'ARNm \n" );
   $t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );

   $t2->insert("end", "$texte" );
   $t2->insert("end", "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
 }


 sub cadr_de_lecture
 {
 # Initialisons les variables
my @fichier_donnees = ();
my $adn = '';
my $proteine = '';
# Lisons le contenu du fichier « exemple.adn »
 $adn1 = $t->get('1.0','end');
$adn = $adn1;
$t2->insert("end", "\n -------cadre de lecture 1--------\n\n" );
$proteine = traduire_cadre($adn, 1);
afficher_sequence($proteine, 70);

$t2->insert("end", "\n -------cadre de lecture 2--------\n\n" );
$proteine = traduire_cadre($adn, 2);
afficher_sequence($proteine, 70);

$t2->insert("end", "\n -------cadre de lecture 3--------\n\n" );
$proteine = traduire_cadre($adn, 3);
afficher_sequence($proteine, 70);
}
sub Traduction_cadr
 {
   $adn1 = $t->get('1.0','end');
   my($adn)=$adn1;

   # Initialisons les variables

   my $proteine = '';

    # Traduisons les codons l'un après l'autre et l'ajouter à la fin
    # de la séquence de protéine
   for ( my $i=0 ; $i < (length($adn) - 2) ; $i += 3)
    {
        $proteine .= codon_en_aa( substr($adn,$i,3) );
    }
    return $proteine;
    }

sub traduire_cadre
  {

    my($sequence, $debut, $fin) = @_;



    # Pour faciliter l'utilisation du sous-programme, vous n'aurez pas
    # à spécifier la position de fin, la fin sera par défaut la fin de la
    # séquence.
    unless ( $fin )
      {
        $fin = length($sequence);
      }

    # Pour terminer, calculer et retourner la traduction
    return Traduction_cadr( substr ( $sequence,
                                     $debut - 1,
                                     $fin - $debut + 1) );
  }

  sub afficher_sequence
  {

    my($sequence, $longueur) = @_;


    # Affichons la séquence par lignes de $longueur caractères
    for ( my $pos = 0 ; $pos < length($sequence) ; $pos += $longueur )
      {
      $az=substr($sequence, $pos, $longueur),"\n";
       $t2->insert("end", "$az" );

      }
  }
  sub Longueur_ADN{
    $adn1 = $t->get('1.0','end');
    $l=$adn1;
    $lo = length($l)-1;
    $t3->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
    $t3->insert("end", "                 la longueur de la séquence (ADN) \n" );
    $t3->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
    $t3->insert("end", "longueur d'ADN est: $lo bases\n" );
    $t3->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
    }

sub Longueur_ARN{
 $texte1=arn($p);
   $texte=substr($texte1,13);
   $texte=~ tr/atcg/ATCG/;
   $texte=~ s/T/U/g;
    $l=$texte;
    $lo = length($l)-1;
    $t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
    $t2->insert("end", "                 la longueur de la séquence (ARN) \n" );
    $t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
    $t2->insert("end", "longueur d'ADN est: $lo bases\n" );
    $t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
    }
  sub stop{
  $adn1 = $t->get('1.0','end');
  $genome=agga($seqag);
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
$t2->insert("end", "                   Traduction en acides amines \n" );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );

$tempGenome = $genome;
$i = 0;
$seq = "";
$orf = 0;

# Frame 0

while (length($tempGenome) > 2 ) {

  $codon = substr($tempGenome, 0, 3, "");
  if ($codon eq "ATG") {
    $orf = 1;
    $start = $i * 3;
  } elsif (($codon eq "TAA") or ($codon eq "TGA") or ($codon eq "TAG")) {
    $end = ($i * 3) + 2;
    $seq .= $codon;
      if ($orf == 1){
      $t2->insert("end", "\n -------cadre de lecture 1--------\n\n" );
   $er= length($seq)/3-1;
     $re="$seq";
     for ( my $i=0; $i < (length($re) - 2) ; $i += 3 )
  {
    $codon     = substr($re,$i,3);
    $proteine .= codon_en_aa($codon);
  }
    $t2->insert("end", "$er.$proteine" );}
    $orf = 0;
    $seq = "";
    $proteine = "";
  }
  $seq .= $codon if $orf == 1;
  ++$i;
}



$tempGenome = substr($genome, 1);
$i = 0;
$seq = "";
$orf = 0;

while (length($tempGenome) > 2 ) {

  $codon = substr($tempGenome, 0, 3, "");
  if ($codon eq "ATG") {
    $orf = 1;
    $start = $i * 3;
  } elsif (($codon eq "TAA") or ($codon eq "TGA") or ($codon eq "TAG")) {
    $end = ($i * 3) + 2;
    $seq .= $codon;
    if ($orf == 1){
    $t2->insert("end", "\n -------cadre de lecture 2--------\n\n" );
     $er= "$start\t$end\t$seq\n";
     $re="$seq";
     for ( my $i=0; $i < (length($re) - 2) ; $i += 3 )
  {
    $codon     = substr($re,$i,3);
    $proteine .= codon_en_aa($codon);
  }
    $t2->insert("end", "$proteine" );}
    $orf = 0;
    $seq = "";
    $proteine = "";
  }
  $seq .= $codon if $orf == 1;
  ++$i;
}

$tempGenome = substr($genome, 2);
$i = 0;
$seq = "";
$orf = 0;

while (length($tempGenome) > 2 ) {

  $codon = substr($tempGenome, 0, 3, "");
  if ($codon eq "ATG") {
    $orf = 1;
    $start = $i * 3;
  } elsif (($codon eq "TAA") or ($codon eq "TGA") or ($codon eq "TAG")) {
    $end = ($i * 3) + 2;
    $seq .= $codon;
     if ($orf == 1){
     $t2->insert("end", "\n -------cadre de lecture 3--------\n\n" );
     $er= "$seq\n";
     $re="$seq";
     for ( my $i=0; $i < (length($re) - 2) ; $i += 3 )
  {
    $codon     = substr($re,$i,3);
    $proteine .= codon_en_aa($codon);
  }
    $t2->insert("end", "$proteine" );}
    $orf = 0;
    $seq = "";
    $proteine = "";
  }
  $seq .= $codon if $orf == 1;
  ++$i;
}
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}


  sub traduction1{
  $adn1 = $t->get('1.0','end');
  $genome=agga($seqag);


$tempGenome = $genome;
$i = 0;
$seq = "";
$orf = 0;

# Frame 0

while (length($tempGenome) > 2 ) {

  $codon = substr($tempGenome, 0, 3, "");
  if ($codon eq "ATG") {
    $orf = 1;
    $start = $i * 3;
  } elsif (($codon eq "TAA") or ($codon eq "TGA") or ($codon eq "TAG")) {
    $end = ($i * 3) + 2;
    $seq .= $codon;
      if ($orf == 1){
      $t2->insert("end", "\n -------cadre de lecture 1--------\n\n" );
     $er= "$start\t$end\t$seq\n";
    $t2->insert("end", "$er" );}
    $orf = 0;
    $seq = "";
  }
  $seq .= $codon if $orf == 1;
  ++$i;
}



$tempGenome = substr($genome, 1);
$i = 0;
$seq = "";
$orf = 0;

while (length($tempGenome) > 2 ) {

  $codon = substr($tempGenome, 0, 3, "");
  if ($codon eq "ATG") {
    $orf = 1;
    $start = $i * 3;
  } elsif (($codon eq "TAA") or ($codon eq "TGA") or ($codon eq "TAG")) {
    $end = ($i * 3) + 2;
    $seq .= $codon;
    if ($orf == 1){
    $t2->insert("end", "\n -------cadre de lecture 2--------\n\n" );
     $er= "$start\t$end\t$seq\n";
    $t2->insert("end", "$er" );}
    $orf = 0;
    $seq = "";
  }
  $seq .= $codon if $orf == 1;
  ++$i;
}

$tempGenome = substr($genome, 2);
$i = 0;
$seq = "";
$orf = 0;

while (length($tempGenome) > 2 ) {

  $codon = substr($tempGenome, 0, 3, "");
  if ($codon eq "ATG") {
    $orf = 1;
    $start = $i * 3;
  } elsif (($codon eq "TAA") or ($codon eq "TGA") or ($codon eq "TAG")) {
    $end = ($i * 3) + 2;
    $seq .= $codon;
     if ($orf == 1){
     $t2->insert("end", "\n -------cadre de lecture 3--------\n\n" );
     $er= "$start\t$end\t$seq\n";
    $t2->insert("end", "$er" );}
    $orf = 0;
    $seq = "";
  }
  $seq .= $codon if $orf == 1;
  ++$i;
}
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}



sub ecor1{
$a=$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
  $adn1 = $t->get('1.0','end');
  $genome=$adn1;
  $e= $genome;
  $e=~ s/GAATTC/G\n--------------ecor1----------------------------------------------------------\nAATTC/g ;
  $t2->insert("end", "$e\n" );


$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}
sub hind3{
$a=$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
  $adn1 = $t->get('1.0','end');
  $genome=$adn1;
  $e= $genome;
  $e=~ s/AAGCTT/A\n--------------HindIII----------------------------------------------------------\nAGCTT/g ;
  $t2->insert("end", "$e\n" );


$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}
sub BamHI_ecor1{
$a=$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
  $adn1 = $t->get('1.0','end');
  $genome=$adn1;
  $e= $genome;
  $e=~ s/GGATCC/G\n--------------BamHI----------------------------------------------------------\nGATCC/g ;
  $e=~ s/GAATTC/G\n--------------ecor1----------------------------------------------------------\nAATTC/g ;
  $t2->insert("end", "$e\n" );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}
sub BamHI_ecor1_hind3{
$a=$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
  $adn1 = $t->get('1.0','end');
  $genome=$adn1;
  $e= $genome;
  $e=~ s/GGATCC/G\n--------------BamHI----------------------------------------------------------\nGATCC/g ;
  $e=~ s/GAATTC/G\n--------------ecor1----------------------------------------------------------\nAATTC/g ;
  $e=~ s/AAGCTT/A\n--------------HindIII----------------------------------------------------------\nAGCTT/g ;
  $t2->insert("end", "$e\n" );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}
sub BamHI{
$a=$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
  $adn1 = $t->get('1.0','end');
  $genome=$adn1;
  $e= $genome;
  $e=~ s/GGATCC/G\n--------------BamHI----------------------------------------------------------\nGATCC/g ;
  $t2->insert("end", "$e\n" );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}

sub porcentage
{

$adn1 = $t->get('1.0','end');
$adn2 = $t->get('1.0','end');
##############27/01/2010## tanger by mojemmi said & RCHOK Fatiha
######this line is used to change the letters min at the word captil
$adn1=~ tr/atcg/ATCG/;
$adn2=~ tr/atcg/ATCG/;
######
$sequence_gc = $adn1 ;
$sequence_at = $adn2 ;
$gc = ( $sequence_gc =~ tr /GC / / ) ;
$at = ( $sequence_at =~ tr /AT / / ) ;

$pourcentage_gc = 100 * ( $gc/length($sequence_gc)) ;
$pourcentage_at = 100 * ( $at/length($sequence_at)) ;
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
$t2->insert("end", "                      pourcentage de AT et GC \n" );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
$t2->insert("end", "GC est: $pourcentage_gc\%\n" );
$t2->insert("end", "AT est: $pourcentage_at\%\n" );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}
sub codon_en_aa
 {
   my($codon) = @_;

   $codon = uc $codon;

   my(%code_genetique) =
      (
       'TCA' => 'S',    # Sérine
       'TCC' => 'S',    # Sérine
       'TCG' => 'S',    # Sérine
       'TCT' => 'S',    # Sérine
       'TTC' => 'F',    # Phénylalanine
       'TTT' => 'F',    # Phénylalanine
       'TTA' => 'L',    # Leucine
       'TTG' => 'L',    # Leucine
       'TAC' => 'Y',    # Tyrosine
       'TAT' => 'Y',    # Tyrosine
       'TAA' => '*',    # Codon Stop
       'TAG' => '*',    # Codon Stop
       'TGC' => 'C',    # Cystéine
       'TGT' => 'C',    # Cystéine
       'TGA' => '*',    # Codon Stop
       'TGG' => 'W',    # Tryptophane
       'CTA' => 'L',    # Leucine
       'CTC' => 'L',    # Leucine
       'CTG' => 'L',    # Leucine
       'CTT' => 'L',    # Leucine
       'CCA' => 'P',    # Proline
       'CCC' => 'P',    # Proline
       'CCG' => 'P',    # Proline
       'CCT' => 'P',    # Proline
       'CAC' => 'H',    # Histidine
       'CAT' => 'H',    # Histidine
       'CAA' => 'Q',    # Glutamine
       'CAG' => 'Q',    # Glutamine
       'CGA' => 'R',    # Arginine
       'CGC' => 'R',    # Arginine
       'CGG' => 'R',    # Arginine
       'CGT' => 'R',    # Arginine
       'ATA' => 'I',    # Isoleucine
       'ATC' => 'I',    # Isoleucine
       'ATT' => 'I',    # Isoleucine
       'ATG' => 'M',    # Méthionine
       'ACA' => 'T',    # Thréonine
       'ACC' => 'T',    # Thréonine
       'ACG' => 'T',    # Thréonine
       'ACT' => 'T',    # Thréonine
       'AAC' => 'N',    # Asparagine
       'AAT' => 'N',    # Asparagine
       'AAA' => 'K',    # Lysine
       'AAG' => 'K',    # Lysine
       'AGC' => 'S',    # Sérine
       'AGT' => 'S',    # Sérine
       'AGA' => 'R',    # Arginine
       'AGG' => 'R',    # Arginine
       'GTA' => 'V',    # Valine
       'GTC' => 'V',    # Valine
       'GTG' => 'V',    # Valine
       'GTT' => 'V',    # Valine
       'GCA' => 'A',    # Alanine
       'GCC' => 'A',    # Alanine
       'GCG' => 'A',    # Alanine
       'GCT' => 'A',    # Alanine
       'GAC' => 'D',    # Acide Aspartique
       'GAT' => 'D',    # Acide Aspartique
       'GAA' => 'E',    # Acide Glutamique
       'GAG' => 'E',    # Acide Glutamique
       'GGA' => 'G',    # Glycine
       'GGC' => 'G',    # Glycine
       'GGG' => 'G',    # Glycine
       'GGT' => 'G',    # Glycine
      );

    if ( exists $code_genetique{$codon} )
      {
        return $code_genetique{$codon};
      }

  }

 sub arn{
  $adn1 = $t->get('1.0','end');
  $arn=$adn1;
  $o=index($arn,'TATAAT');
  $p=substr($arn,$o);
  return $p;
  }
  sub agga{
  $agga=arn($p);
  $seqa=index($agga,'AGGA');
  $seqag=substr($agga,$seqa);
  return $seqag;
  }
sub arn1{
  $adn1 = $t->get('1.0','end');
  $arn=$adn1;
  $o=index($arn,'TATAAT');
  return $o;
  }
sub agga1{
  $agga=arn($p);
  $seqa=index($agga,'AGGA');
  return $seqa;
  }
sub afficher_TATAAT{
$seq12=arn1($o);
$t2 -> insert ( 'end' , "la position de la sequence TATAAT est: $seq12\n" ) ;
}

sub afficher_AGGA{
$seq13=agga1($seqa);
$t2 -> insert ( 'end' , "$seq13\n" ) ;
}

sub statistique
{

 $adn1 = $t->get('1.0','end');
   @adn=$adn1;
   $adn1=join("",@adn);
   $adn1=~ s/\s//g;
   @adn=split("",$adn1);
   $nbr_A=0;$nbr_C=0;$nbr_D=0;$nbr_E=0;
   $nbr_F=0;$nbr_G=0;$nbr_H=0;$nbr_I=0;
   $nbr_K=0;$nbr_L=0;$nbr_M=0;$nbr_N=0;
   $nbr_P=0;$nbr_Q=0;$nbr_R=0;$nbr_S=0;
   $nbr_T=0;$nbr_V=0;$nbr_W=0;$nbr_Y=0;
   $nbr_codon_stop=0;

   foreach $base( @adn)
   {
     if(($base eq "a")or($base eq "A" )){
         $nbr_A++;
         }
     elsif(($base eq "c")or($base eq "C" )){
         $nbr_C++;
         }
     elsif(($base eq "d")or($base eq "D" )){
         $nbr_D++;
         }
     elsif(($base eq "e")or($base eq "E" )){
         $nbr_E++;
         }
     elsif(($base eq "f")or($base eq "F" )){
         $nbr_F++;
         }
     elsif(($base eq "h")or($base eq "H" )){
         $nbr_H++;
         }
     elsif(($base eq "i")or($base eq "I" )){
         $nbr_I++;
         }
     elsif(($base eq "k")or($base eq "K" )){
         $nbr_K++;
         }
     elsif(($base eq "l")or($base eq "L" )){
         $nbr_L++;
         }
     elsif(($base eq "m")or($base eq "M" )){
         $nbr_M++;
         }
     elsif(($base eq "n")or($base eq "N" )){
         $nbr_N++;
         }
     elsif(($base eq "p")or($base eq "P" )){
         $nbr_P++;
         }
     elsif(($base eq "q")or($base eq "Q" )){
         $nbr_Q++;
         }
     elsif(($base eq "r")or($base eq "R" )){
         $nbr_R++;
         }
     elsif(($base eq "s")or($base eq "S" )){
         $nbr_S++;
         }
     elsif(($base eq "t")or($base eq "T" )){
         $nbr_T++;
         }
     elsif(($base eq "v")or($base eq "V" )){
         $nbr_V++;
         }
     elsif(($base eq "w")or($base eq "W" )){
         $nbr_W++;
         }
     elsif(($base eq "y")or($base eq "Y" )){
         $nbr_Y++;
         }
     elsif(($base eq "*")or($base eq "*" )){
         $nbr_codon_stop++;
         }
     elsif(($base eq "c")or($base eq "C" )){
         $nbr_C++;
         }
     elsif(($base eq "g")or($base eq "G" )){
         $nbr_G++;
         }else{

         }
   }
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  A  est : $nbr_A \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  C  est : $nbr_C \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  D  est : $nbr_D \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  E  est : $nbr_E \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  F  est : $nbr_F \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  G  est : $nbr_G \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  H  est : $nbr_H \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  I  est : $nbr_I \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  M  est : $nbr_M \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  N  est : $nbr_N \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  P  est : $nbr_P \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  Q  est : $nbr_Q \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  R  est : $nbr_R \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  S  est : $nbr_S \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  T  est : $nbr_T \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  V  est : $nbr_V \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  W  est : $nbr_W \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de l\'acide amine  Y  est : $nbr_Y \n" ) ;
  $t2 -> insert ( 'end' , "le nombre de codon stop est        : $nbr_codon_stop \n" ) ;

 }








 sub rev{

$adn1 = $t->get('1.0','end');

@DNA = $adn1;

$DNA = join( '', @DNA);
$DNA =~ s/\s//g;
@DNA = split( '', $DNA );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
$t2->insert("end", "                  Chaine Complementaire inverse 5'->3' \n" );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );

foreach $nucleotide(reverse(@DNA)) {



    if      ($nucleotide =~ /a/i) {
        $t2->insert("end", "T" );
        print WRITE "T";
    } elsif ($nucleotide =~ /t/i) {
        $t2->insert("end", "A" );
        print WRITE "A";
    } elsif ($nucleotide =~ /g/i) {
        $t2->insert("end", "C" );
        print WRITE "C";
    } elsif ($nucleotide =~ /c/i) {
        $t2->insert("end", "G" );
        print WRITE "G";
    }
}
$t2->insert("end", "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}
 sub rev_comp{

$adn1 = $t->get('1.0','end');

@DNA = $adn1;
$DNA = join( '', @DNA);
$DNA =~ s/\s//g;
@DNA = split( '', $DNA );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
$t2->insert("end", "                    Chaine Complementaire 3'->5'\n" );
$t2->insert("end", "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );

foreach $nucleotide(@DNA) {



    if      ($nucleotide =~ /a/i) {
        $t2->insert("end", "T" );
        print WRITE "T";
    } elsif ($nucleotide =~ /t/i) {
        $t2->insert("end", "A" );
        print WRITE "A";
    } elsif ($nucleotide =~ /g/i) {
        $t2->insert("end", "C" );
        print WRITE "C";
    } elsif ($nucleotide =~ /c/i) {
        $t2->insert("end", "G" );
        print WRITE "G";
    }
}
$t2->insert("end", "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" );
}

sub salut
{
my ( $texte1 ) ;

$texte1 = $zone_saisie2 -> get ( ) ;
$t3->insert('end',"Votre recherche par id [GenBank] est:$texte1\n");
$gb = new Bio::DB::GenBank;
$seq = $gb->get_Seq_by_id($texte1); # Unique ID
$a2=$seq->seq();
$b2=$seq->id();
$b3=$seq->length();
$b4=$seq->accession_number();
$b5=$seq->desc();
if(sq){
$t -> insert ( 'end' , "sequence:  $a2 \n" ) ;
}
if(id){
$t -> insert ( 'end' , " id: $b2 \n" ) ;
}
if(leng){
$t -> insert ( 'end' , "longueur:  $b3 \n" ) ;
}
if(desc){
$t -> insert ( 'end' , "numero d'accès:  $b5 \n" ) ;
}
if(acn){
$t -> insert ( 'end' , "description:  $b4 \n" ) ;
}
}



sub swissprot
{
my ( $texte2 ) ;
$texte2 = $zone_saisie02 -> get ( ) ;
$t3->insert('end',"Votre recherche par id [swissprot] est:$texte2\n");
my $database = new Bio::DB::SwissProt;
my $seq = $database->get_Seq_by_id($texte2);
$a2=$seq->seq();
$b2=$seq->id();
$b3=$seq->length();
$b4=$seq->accession_number();
$b5=$seq->desc();
if(sq){
$t3 -> insert ( 'end' , "sequence: $a2 \n," ) ;
}
if(id0){
$t3 -> insert ( 'end' , "id:  $b2 \n" ) ;
}
if(leng0){
$t3 -> insert ( 'end' , "longueur:  $b3 \n" ) ;
}
if(desc0){
$t3 -> insert ( 'end' , "numero d'accès:  $b5 \n" ) ;
}
if(acn0){
$t3 -> insert ( 'end' , "description:  $b4 \n" ) ;
}
}


sub recherche_par_nom {
        my $name="";
        my @pl = qw/-side top -pady 2 -anchor w/;
        my ($id,$de,$lc,$os,$cx,$sq)=(1,0,1,0,0,0);
        my $popup=$f->DialogBox(-title=>"recherche par nom",-buttons => ['OK','Cancel']);
        $popup -> geometry("250x300");
        $popup -> add('Label',-text=>'Entrez le nom')->pack(@pl);
        my $name_entry = $popup -> add('Entry')->pack(@pl);

        $popup -> add('Label',-text=>'Sélectionnez quels domaines vous souhaitez afficher')->pack(@pl);
        $popup -> add('Checkbutton',-text=>' ID',-variable=>\$id,-relief=>'flat',-anchor=>'w',-onvalue=>1,-offvalue=>0)->pack(@pl);
        $popup -> add('Checkbutton',-text=>'Localisation dans la cellules',-variable=>\$lc,-relief=>'flat',-anchor=>'w',-onvalue=>1,-offvalue=>0)->pack(@pl);
        $popup -> add('Checkbutton',-text=>'base de données ',-variable=>\$cx,-relief=>'flat',-anchor=>'w',-onvalue=>1,-offvalue=>0)->pack(@pl);
        $popup -> add('Checkbutton',-text=>'Description',-variable=>\$de,-relief=>'flat',-anchor=>'w',-onvalue=>1,-offvalue=>0)->pack(@pl);
        $popup -> add('Checkbutton',-text=>'Organisme',-variable=>\$os,-relief=>'flat',-anchor=>'w',-onvalue=>1,-offvalue=>0)->pack(@pl);
        $popup -> add('Checkbutton',-text=>'Sequence',-variable=>\$sq,-relief=>'flat',-anchor=>'w',-onvalue=>1,-offvalue=>0)->pack(@pl);


        $popup -> add('Label',-text=>"Notez que la recherche peut-être assez lent \nVeuillez être patient")->pack(@pl);
        my $button = $popup->Show;
        if($button eq "OK") {
                my $name = $name_entry ->get;
                $t3->insert('end',"Votre recherche par nom: name=$name\n");
                my $search_result="";
                my $returnValue = $server -> name_search($name);
                for(my $index=0;$index<=$#$returnValue;$index++){
                   $returnValue->[$index]->{ID} =~ s/\n/ /g;
                    $returnValue->[$index]->{DE} =~ s/\n/ /g;
                    $returnValue->[$index]->{OS} =~ s/\n/ /g;
                    $returnValue->[$index]->{SQ} =~ s/\n/ /g;
                    $returnValue->[$index]->{LC} =~ s/\n/ /g;
                    $returnValue->[$index]->{CX} =~ s/\n/ /g;
                    if($id){
                    $search_result.= "ID\t".$returnValue->[$index]->{ID}."\n";
                    }
                    if($de){
                    $search_result.= "DE\t".$returnValue->[$index]->{DE}."\n";
                    }
                    if($lc){
                    $search_result.= "LC\t".$returnValue->[$index]->{LC}."\n";
                    }
                    if($os){
                    $search_result.= "OS\t".$returnValue->[$index]->{OS}."\n";
                    }
                    if($cx){
                    $search_result.= "CX\t".$returnValue->[$index]->{CX}."\n";
                    }
                    if($sq){
                    $search_result.= "SQ\t".$returnValue->[$index]->{SQ}."\n";
                    }
                    $search_result.="//\n";
                }
                $t->delete('1.0','end');
                $t->insert('end',$search_result);
        }
        if($button eq 'Cancel'){
                $log_area->insert('end',"recherche annulée\n");
        }
}
sub search_by_blast {
        #my $name="";
        my @pl = qw/-side top -pady 2 -anchor w/;
        my $isplain= 1;
        my $popup=$f->DialogBox(-title=>"recherche par  blast",-buttons => ['lire','quiter']);
        $popup -> geometry("300x250");
        $popup -> add('Label',-text=>"S’il vous plaît saisir les séquences en format fasta ")->pack(@pl);
        $popup -> add('Label',-text=>"Notez que la recherche peut-être assez lent \nVeuillez être patient")->pack(@pl);
        $popup -> add('Label',-text=>'Sélectionnez le type de sortie, vous souhaitez afficher:')->pack(@pl);
        $popup -> add('Radiobutton',-text => ' originale sortie de BLAST',-variable => \$isplain,-relief =>'flat',-anchor=>'w',-value=>1)->pack(@pl);
        $popup -> add('Radiobutton',-text => 'Analysés LA SORTIE ',-variable => \$isplain,-relief =>'flat',-anchor=>'w',-value=>0)->pack(@pl);
        $popup -> add('Label',-text=>"Entrez le e-valeur seuil")->pack(@pl);
        my $evalue_entry = $popup -> add('Entry');
        my $button = $popup->Show;
        if($button eq "lire") {
                my $evalue=$evalue_entry->get;
                my $seqio = IO::String -> new($t ->get('1.0','end'));
                my $fasta = Bio::SeqIO -> new('-fh'=>$seqio,'-format'=>'fasta');
                $t2->delete('1.0','end');
                while (my $seq = $fasta->next_seq){
                        $t3->insert('end',"Votre recherche par blast\n");
                        $t3->insert('end',($seq->id()).($seq->desc())."evalue:".$evalue.("\n"));
                        $t2->insert('end',"Votre Blast Resultat pour ".($seq->id())."  ".($seq->desc())." evalue: ".$evalue.("\n"));
                        if($isplain){
                        $t2->insert('end',$server-> blast_search('all','full',$seq->seq(),$evalue)->{plain});
                        }
                        else{
                        $t2->insert('end',$server-> blast_search('all','full',$seq->seq(),$evalue)->{parsed});
                        }
                }
        }
        if($button eq 'quiter'){
                $t2->insert('end',"\n");
        }
}