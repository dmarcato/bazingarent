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

print "Content-type: text/plain\n\n".$status;

exit(0);