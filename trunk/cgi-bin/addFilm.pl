#!/usr/bin/perl -w

use CGI::Session;
use CGI;

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
	my $first = $radice->getFirstChild();
	$radice->insertAfter($frammento, $first);
	# Scrive il documento modificato nel file XML d'origine
	open(FILE,">$listaFilm") || die("non apro il file db");
	print FILE $doc->toString();
	close(FILE);
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

# Aggiunta film
#print "Content-type: text/plain\n\n".$status;

use XML::LibXML;

my $page = new CGI;

print $page->start_html( # inizio pagina HTML
		-title => 'Aggiunta film',
		-charset =>'UTF-8',
		-dtd =>[ '-//W3C//DTD XHTML 1.0 Strict//EN','http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'],
		-lang =>'it',
		-meta => {'keywords' => 'noleggio, video, film, bazinga',
			'description' => 'Noleggio film',
			'author' => 'BazingaSoft'},
		-style => [{-src => ['../css/main.css'],
			-media => 'screen'},
			{-src => ['../css/mobile.css'],
			-media => 'handheld'}],
		-script => [{-src => '../js/jquery-1.4.2.min.js'}, '$(document).ready(function() { $("#lettera'.$lettera.'").addClass("current"); });'] 
);

print "<div id='header'>\n
	</div>\n";
		
print "<div id='path'>\n
		<ul id='navigazione'>\n
			<li><a href='../index.html'>Home</a></li>\n
			<li><a href='#'>Catalogo</a></li>\n
			<li><a href='../noleggiati.html'>I pi&ugrave; noleggiati</a></li>\n
			<li><a href='../trovaci.html'>Come trovarci</a></li>\n
			<li><a href='../prossimamente.html'>Prossimamente</a></li>\n
		</ul>\n
	</div>\n";
	
print "<div id='content'>\n

		<h1>Aggiunta film</h1>\n

		<div class='contBox'>\n";

my $file = '../xml/film.xml';
#creazione oggetto parser
my $parser = XML::LibXML->new();
#apertura file e lettura input
my $doc = $parser->parse_file($file);
my $radice= $doc->getDocumentElement; #estrazione radice
my $elementi = "/lista/film";
my @film = $doc->findnodes($elementi);
my $length = @film;
	
my $found = 0;
my $titolo;
my $j = 0;
	
my $lista = '';
	
for(my $i=0; $i < $length;$i++) {
	$titolo = $film[$i]->getElementsByTagName('titolo');
	if (($cerca && $titolo =~ /$cerca/i) || (!$cerca && $titolo =~ /^$lettera/i)) {
		$found++;
		my $tipoBox = '';
		if($j == 0) {
			$tipoBox = 'boxFilmL';
			$j = 1;
		} else {
			$tipoBox = 'boxFilmR';
			$j = 0;
		}
		$lista .= "<div class='boxFilmL'>\n
				<img src=".$film[$i]->getElementsByTagName('image')." alt=".$film[$i]->getElementsByTagName('titolo')." />\n
				<p class='titolo'>".$film[$i]->getElementsByTagName('titolo')."</p>\n
				<p class='info'>".$film[$i]->getElementsByTagName('uscita')."</p>\n
				<div class='descr'>\n
					<p class='descrizione'>".$film[$i]->getElementsByTagName('descrizione')."</p>\n
				</div>\n
				<a title='Scheda film' class='more' target='_blank' href=".$film[$i]->getElementsByTagName('link').">Scheda film</a>\n
			</div>";
		#print $titolo[$i]." ".$i." ";
	}
}

print "<h4>Risultati ottenuti: ".$found."</h4>";

print $lista;

print "</div>\n

	</div>\n
	<div id='footer'>\n
		<a href='http://validator.w3.org/check?uri=referer'><img src='../images/xhtmlstkt.gif' alt='Valid XHTML 1.0 Strict' /></a>&nbsp;
		&copy;2010 BazingaSoft&nbsp;
		<a href='http://validator.w3.org/check?uri=referer'><img src='../images/css2.gif' alt='Valid CSS 2' /></a>
	</div>\n";

$page->end_html;

exit(0);