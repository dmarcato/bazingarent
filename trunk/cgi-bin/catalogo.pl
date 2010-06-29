#!/usr/bin/perl -w
print "Content-type: text/html\r\n\r\n";

use strict;
use CGI ':standard';
use XML::LibXML;
use utf8;
use Encode qw/is_utf8 decode/;
binmode(STDOUT, ":utf8");

my $lettera = param('letter');
if (!$lettera) {
	$lettera = 'A';
}

my $cerca = param('txtCerca');

my $page = new CGI;

#$page->header(-charset=>'UTF-8'); # crea l'header HTTP
print $page->start_html( # inizio pagina HTML
		-title => 'Catalogo - Bazinga Rent',
		-encoding => 'UTF-8',
		-dtd =>[ '-//W3C//DTD XHTML 1.0 Strict//EN','http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'],
		-lang =>'it',
		-meta => {'keywords' => 'noleggio, video, film, bazinga',
			'description' => 'Noleggio film',
			'author' => 'BazingaSoft'},
		-style => [{-src => ['../css/main.css'],
			-media => 'screen'},
			{-src => ['../css/mobile.css'],
			-media => 'handheld'},
			{-src => ['../css/print.css'],
			-media => 'print'}],
		-script => [{-src => '../js/jquery-1.4.2.min.js'}, '$(document).ready(function() { $("#lettera'.$lettera.'").addClass("current"); });'] 
);

print "<div id='header'>\n
		<span>Bazinga Rent</span>\n
	</div>\n";
		
print '<div id="path">
			<ul id="navigazione">
				<li><a title="Home del sito" href="../index.html" tabindex="1" accesskey="h">Home</a></li>
				<li class="current"><a title="I film a disposizione" href="./cgi-bin/catalogo.pl" tabindex="2" accesskey="c">Catalogo</a></li>
				<li><a title="I pi&ugrave; noleggiati" href="../noleggiati.html" tabindex="3" accesskey="n">I pi&ugrave; noleggiati</a></li>
				<li><a title="Come trovarci" href="../trovaci.html" tabindex="4" accesskey="t">Come trovarci</a></li>
				<li><a title="I prossimi arrivi" href="../prossimamente.html" tabindex="5" accesskey="p">Prossimamente</a></li>
			</ul>
		</div>';
	
print "<div id='content'>\n

		<h1>Catalogo</h1>\n

		<div id='cerca'>\n
			<form action='#' method='get'>\n
				<div>\n
				<label for='txtCerca'>Cerca:</label>&nbsp;<input type='text' id='txtCerca' name='txtCerca' value='".$cerca."' />&nbsp;<input type='submit' value='Vai!' />\n
				</div>\n
			</form>\n
		</div>\n
		
		<p class='lettereCatalogo'>
			<a href='?letter=1' id='lettera1'>#</a>&nbsp;
			<a href='?letter=A' id='letteraA'>A</a>&nbsp;
			<a href='?letter=B' id='letteraB'>B</a>&nbsp;
			<a href='?letter=C' id='letteraC'>C</a>&nbsp;
			<a href='?letter=D' id='letteraD'>D</a>&nbsp;
			<a href='?letter=E' id='letteraE'>E</a>&nbsp;
			<a href='?letter=F' id='letteraF'>F</a>&nbsp;
			<a href='?letter=G' id='letteraG'>G</a>&nbsp;
			<a href='?letter=H' id='letteraH'>H</a>&nbsp;
			<a href='?letter=I' id='letteraI'>I</a>&nbsp;
			<a href='?letter=J' id='letteraJ'>J</a>&nbsp;
			<a href='?letter=K' id='letteraK'>K</a>&nbsp;
			<a href='?letter=L' id='letteraL'>L</a>&nbsp;
			<a href='?letter=M' id='letteraM'>M</a>&nbsp;
			<a href='?letter=N' id='letteraN'>N</a>&nbsp;
			<a href='?letter=O' id='letteraO'>O</a>&nbsp;
			<a href='?letter=P' id='letteraP'>P</a>&nbsp;
			<a href='?letter=Q' id='letteraQ'>Q</a>&nbsp;
			<a href='?letter=R' id='letteraR'>R</a>&nbsp;
			<a href='?letter=S' id='letteraS'>S</a>&nbsp;
			<a href='?letter=T' id='letteraT'>T</a>&nbsp;
			<a href='?letter=U' id='letteraU'>U</a>&nbsp;
			<a href='?letter=V' id='letteraV'>V</a>&nbsp;
			<a href='?letter=W' id='letteraW'>W</a>&nbsp;
			<a href='?letter=X' id='letteraX'>X</a>&nbsp;
			<a href='?letter=Y' id='letteraY'>Y</a>&nbsp;
			<a href='?letter=Z' id='letteraZ'>Z</a>
		</p>
		
		<div class='contBox'>\n";

if ($lettera =~ '1') {
	$lettera = '[0-9]';
}

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
		$lista .= "<div class='".$tipoBox."'>\n
				<img src='".$film[$i]->getElementsByTagName('image')."' alt='".$film[$i]->getElementsByTagName('titolo')."' />\n
				<p class='titolo'>".$film[$i]->getElementsByTagName('titolo')."</p>\n
				<p class='info'>".$film[$i]->getElementsByTagName('uscita')."</p>\n
				<p class='disp'>Disponibilit&agrave;: ".$film[$i]->getElementsByTagName('disp')."</p>\n
				<div class='descr'>\n
					<p class='descrizione'>".$film[$i]->getElementsByTagName('descrizione')."</p>\n
				</div>\n
				<a title='Scheda film' class='more' href='".$film[$i]->getElementsByTagName('link')."'>Scheda film</a>\n
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

print $page->end_html;