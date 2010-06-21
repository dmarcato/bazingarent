#!/usr/bin/perl -w

use CGI::Session;
use CGI ':standard';
use utf8;
use Encode qw/is_utf8 decode/;
binmode(STDOUT, ":utf8");

$query = new CGI;
$cookie = $query->cookie(-name => "session");
if ($cookie) {
  CGI::Session->name($cookie);
}
$session = new CGI::Session("driver:File",$cookie,{'Directory'=>"/tmp"}) or die "$!";
$status = $session->param('status');

# Parte di login
if (!($status eq 'administrator')) {
	print "Content-type: text/html\r\n\r\n";
	open FILE, "../login.html" or die "$!";
	binmode FILE;
	my ($data, $n);
	while (($n = read FILE, $data, 4) != 0) {
	  print $data;
	}
	close(FILE);
	exit(0);
}

# Aggiunta film
my $insert = param('insert');
if ($insert) {
	my $titolo = param('titolo');
	my $regista = param('regista');
	my $cast = param('cast');
	my $genere = param('genere');
	my $uscita = param('uscita');
	my $descrizione = param('descrizione');
	my $image = param('image');
	my $dataGG = param('dataGG');
	my $dataMM = param('dataMM');
	my $dataAA = param('dataAA');
	my $link = param('link');
	my $disp = param('disp');
	my $noleggi = param('noleggi');
	
	use XML::LibXML;
	my $listaFilm = '../xml/film.xml';
	my $parser = XML::LibXML->new();
	my $doc = $parser -> parse_file($listaFilm);
	my $radice= $doc->getDocumentElement;
	my @lastFilm = $doc->findnodes("/lista/film[last()]");
	my $id = $lastFilm[0]->getAttribute('id') + 1;
	my $nuovo = "<film id=\"$id\">
	<titolo>$titolo</titolo>
	<regista>$regista</regista>
	<cast>$cast</cast>
	<genere>$genere</genere>
	<uscita>$uscita</uscita>
	<descrizione>$descrizione</descrizione>
	<image>$image</image>
	<data>
		<anno>$dataAA</anno>
		<mese>$dataMM</mese>
		<giorno>$dataGG</giorno>
	</data>
	<link>$link</link>
	<disp>$disp</disp>
	<noleggi>$noleggi</noleggi>
	</film> ";
	# Parsing del nuovo nodo
	my $frammento = $parser->parse_balanced_chunk($nuovo);
	# Viene aggiunto in coda il nodo creato prima
	#my $first = $radice->getFirstChild();
	$radice->insertAfter($frammento, $radice);
	# Scrive il documento modificato nel file XML d'origine
	open(FILE,">$listaFilm") || die("non apro il file db");
	print FILE $doc->toString();
	close(FILE);
	print "Content-type: text/plain\n\nFilm aggiunto";
	print '<a href="javascript:history.back();">Torna indietro</a>';
	exit(0);
}

print "Content-type: text/html\r\n\r\n";
open FILE, "../addFilm.html" or die "$!";
binmode FILE;
my ($data, $n);
while (($n = read FILE, $data, 4) != 0) {
  print $data;
}
close(FILE);
exit(0);