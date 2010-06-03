#!/usr/bin/perl -w
print "Content-type: text/html\r\n\r\n";

use strict;
use CGI ':standard';
use XML::LibXML;

my $page = new CGI;

#$page->header(-charset=>'UTF-8'); # crea l’header HTTP
print $page->start_html( # inizio pagina HTML
		-title => 'Catalogo',
		-charset =>'UTF-8',
		-dtd =>[ '-//W3C//DTD XHTML 1.0 Strict//EN','http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'],
		-lang =>'it',
		-meta => {'keywords' => 'noleggio, video, film, bazinga',
			'description' => 'Noleggio film',
			'author' => 'BazingaSoft'},
		-style => {-src => ['../css/main.css'],
			-media => 'screen'}
);

print "<div id='header'>\n
	</div>\n";
		
print "<div id='path'>\n
		<ul id='navigazione'>\n
			<li><a href='../index.html'>Home</a></li>\n
			<li class='current'><a href='#'>Catalogo</a></li>\n
			<li><a href='../noleggiati.html'>I pi&ugrave; noleggiati</a></li>\n
			<li><a href='../trovaci.html'>Come trovarci</a></li>\n
			<li><a href='../prossimamente.html'>Prossimamente</a></li>\n
		</ul>\n
	</div>\n";
	
my $lettera = param('letter');
if (!$lettera) {
	$lettera = 'A';
}

my $cerca = param('txtCerca');
	
print "<div id='content'>\n

		<h1>Catalogo</h1>\n

		<div id='cerca'>\n
			<form action='#' method='get'>\n
				Cerca: <input type='text' id='txtCerca' name='txtCerca' value='".$cerca."' />&nbsp;<input type='submit' value='Vai!' />\n
			</form>\n
		</div>\n
		
		<p class='lettereCatalogo'>
			<a href='?letter=1'>#</a>
			<a href='?letter=A'>A</a>
			<a href='?letter=B'>B</a>
			<a href='?letter=C'>C</a>
			<a href='?letter=D'>D</a>
			<a href='?letter=E'>E</a>
			<a href='?letter=F'>F</a>
			<a href='?letter=G'>G</a>
			<a href='?letter=H'>H</a>
			<a href='?letter=I'>I</a>
			<a href='?letter=J'>J</a>
			<a href='?letter=K'>K</a>
			<a href='?letter=L'>L</a>
			<a href='?letter=M'>M</a>
			<a href='?letter=N'>N</a>
			<a href='?letter=O'>O</a>
			<a href='?letter=P'>P</a>
			<a href='?letter=Q'>Q</a>
			<a href='?letter=R'>R</a>
			<a href='?letter=S'>S</a>
			<a href='?letter=T'>T</a>
			<a href='?letter=U'>U</a>
			<a href='?letter=V'>V</a>
			<a href='?letter=W'>W</a>
			<a href='?letter=X'>X</a>
			<a href='?letter=Y'>Y</a>
			<a href='?letter=Z'>Z</a>
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