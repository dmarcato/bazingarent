#!/usr/bin/perl -w

use CGI::Session;
use CGI ':standard';
use XML::LibXML;

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

# Eliminazione film
my $deleteId = param('deleteId');
if ($deleteId) {
	my $listaFilm = '../xml/film.xml';
	my $parser = XML::LibXML->new();
	my $doc = $parser -> parse_file($listaFilm);
	my $radice= $doc->getDocumentElement;
	my ($lastFilm) = $doc->findnodes('lista/film[@id="'.$deleteId.'"]');
	$lastFilm->unbindNode;
	# Scrive il documento modificato nel file XML d'origine
	#open(FILE,">$listaFilm") || die("non apro il file db");
	#print FILE $doc->toString();
	#close(FILE);
	print "Content-type: text/plain\n\nFilm eliminato\n";
	print $deleteId."\n";
	print $doc->toString;
	exit(0);
}

print "Content-type: text/html\r\n\r\n";
print $query->start_html( # inizio pagina HTML
		-title => 'Eliminazione film',
		-charset =>'UTF-8',
		-dtd =>[ '-//W3C//DTD XHTML 1.0 Strict//EN','http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'],
		-lang =>'it',
		-meta => {'keywords' => 'noleggio, video, film, bazinga',
			'description' => 'Noleggio film',
			'author' => 'BazingaSoft'},
		-style => [{-src => ['../css/main.css'],
			-media => 'screen'},
			{-src => ['../css/mobile.css'],
			-media => 'handheld'}]
);

my $file = '../xml/film.xml';
#creazione oggetto parser
my $parser = XML::LibXML->new();
#apertura file e lettura input
my $doc = $parser->parse_file($file);
my $radice= $doc->getDocumentElement; #estrazione radice
my $elementi = "/lista/film";
my @film = $doc->findnodes($elementi);
my $length = @film;
	
my $options = '';

for(my $i=0; $i < $length;$i++) {
	$titolo = $film[$i]->getElementsByTagName('titolo');
	$id = $film[$i]->findvalue('@id');
	$options .= '<option value="'.$id.'">'.$titolo.'</option>';
}

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
	
print "<div id='content'>\n

		<h1>Eliminazione film</h1>\n
		
		<div class='contBox'>\n
		
		<form action=\"#\" method=\"post\">
		Scegli il film da eliminare:&nbsp;
		<select name=\"deleteId\">".$options."</select><br />
		<input type=\"submit\" value=\"Elimina\" />
		</form>
		
		</div>\n
	</div>\n
	<div id='footer'>\n
		<a href='http://validator.w3.org/check?uri=referer'><img src='../images/xhtmlstkt.gif' alt='Valid XHTML 1.0 Strict' /></a>&nbsp;
		&copy;2010 BazingaSoft&nbsp;
		<a href='http://validator.w3.org/check?uri=referer'><img src='../images/css2.gif' alt='Valid CSS 2' /></a>
	</div>\n";

$query->end_html;

exit(0);