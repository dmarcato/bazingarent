#!c:/wamp/bin/perl/bin/perl
print "Content-type: text/html\r\n\r\n";

use strict;
use CGI ':standard';
use XML::LibXML;
 
my $cerca = param('txtCerca');

my $page = new CGI;

#$page->header(-charset=>'UTF-8'); # crea l’header HTTP
print $page->start_html( # inizio pagina HTML
		-title => 'Risultati ricerca',
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
			<li class='current'><a href='../catalogo.html'>Catalogo</a></li>\n
			<li><a href='../noleggiati.html'>I pi&ugrave; noleggiati</a></li>\n
			<li><a href='../trovaci.html'>Come trovarci</a></li>\n
			<li><a href='../prossimamente.html'>Prossimamente</a></li>\n
		</ul>\n
	</div>\n";
	
print "<div id='content'>\n
		<div id='cerca'>\n
			<form action='./cerca.pl' method='get'>\n
				Cerca: <input type='text' id='txtCerca' name='txtCerca' /><input type='submit' value='Vai!' />\n
			</form>\n
		</div>\n
		
		<h1>Risultati ricerca:</h1>\n
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

for(my $i=0; $i < $length;$i++) {
	$titolo = $film[$i]->getElementsByTagName('titolo');
	if($titolo =~ /$cerca/i) {
		$found++;
		if($j == 0) {
			print "<div class='boxFilmL'>\n
					<img src=".$film[$i]->getElementsByTagName('image')." alt=".$film[$i]->getElementsByTagName('titolo')." />\n
					<p class='titolo'>".$film[$i]->getElementsByTagName('titolo')."</p>\n
					<p class='info'>".$film[$i]->getElementsByTagName('uscita')."</p>\n
					<div class='descr'>\n
						<p class='descrizione'>".$film[$i]->getElementsByTagName('descrizione')."</p>\n
					</div>\n
					<a title='Scheda film' class='more' target='_blank' href=".$film[$i]->getElementsByTagName('link').">Scheda film</a>\n
				</div>";
			$j = 1;
		}
		else {
			print "<div class='boxFilmR'>\n
					<img src=".$film[$i]->getElementsByTagName('image')." alt=".$film[$i]->getElementsByTagName('titolo')." />\n
					<p class='titolo'>".$film[$i]->getElementsByTagName('titolo')."</p>\n
					<p class='info'>".$film[$i]->getElementsByTagName('uscita')."</p>\n
					<div class='descr'>\n
						<p class='descrizione'>".$film[$i]->getElementsByTagName('descrizione')."</p>\n
					</div>\n
					<a title='Scheda film' class='more' target='_blank' href=".$film[$i]->getElementsByTagName('link').">Scheda film</a>\n
				</div>\n";
			$j = 0;
		}
		#print $titolo[$i]." ".$i." ";
	}
}

print "</div>\n
	<b>Risultati ottenuti:</b>".$found."\n
	</div>\n
	<div id='footer'>\n
		&copy;2010 BazingaSoft\n
	</div>\n";

$page->end_html;