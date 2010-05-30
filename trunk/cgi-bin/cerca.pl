#!c:/wamp/bin/perl/bin/perl
print "Content-type: text/html\r\n\r\n";

use strict;
use CGI ':standard';
use XML::LibXML;
 
my $cerca = param('txtCerca');

my $file = '../xml/film.xml';
#creazione oggetto parser
my $parser = XML::LibXML->new();
#apertura file e lettura input
my $doc = $parser->parse_file($file);
my $radice= $doc->getDocumentElement; #estrazione radice
my $elementi = "/lista/film";
my @film = $doc->findnodes($elementi);

my $titolo = $film[0]->findnodes('./titolo');
print $titolo;

#my $length = @elementi;
#
#for(my $i=0; $i < $length;$i++) {
#	print $elementi[$i]." ";
#}