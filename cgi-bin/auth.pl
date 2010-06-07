#!/usr/bin/perl -w

use CGI::Session;
use CGI;

# Get the CGI form data
$query = new CGI;

if ($query->param('logout')) {
  # Logout part
  # Get the session id
  $cookie = $query->cookie(-name => "session");
  if ($cookie) {
    CGI::Session->name($cookie);
  }
  # Expire the server session
  $session = new CGI::Session("driver:File",$cookie,{'Directory'=>"/tmp"}) or die "$!";
  $session->clear();
  $session->expire('+2h');
  # Remove the session cookie
  print "Set-Cookie: session=$id; domain=.$host; path=/; expires=Sat, 8-Oct-2001 01:01:01 GMT\n";
  # Goes back to the identification page
  print "Location: ".$ENV{'HTTP_REFERER'}."\n\n";
  exit(0);
}

# Initiate the session
$session = new CGI::Session("driver:File",undef,{'Directory'=>"/tmp"});

# Fetch login and password
$login = $query->param('login');
$login =~ s/(?:\012\015|\012|\015)//g;
$pwd = $query->param('pwd');
$pwd =~ s/(?:\012\015|\012|\015)//g;

# Check the credentials and populate the status variable
if (($login eq 'admin') and ($pwd eq 'admin')) {
  $zstatus = 'administrator';
} else {
  #print "Content-type: text/plain\n\nNope !";
  print "Location: ../accesso_negato.html\n\n";
  exit(0);
}

# Write the session variable on the server
$session->param('status',$zstatus);
$session->expire('+2h');

# Send the cookie linking the user to the server session
$id = $session->id();
$host = $ENV{'HTTP_HOST'};
print "Set-Cookie: session=$id; domain=.$host; path=/\n";

# Goes back to the main page
print "Location: ".$ENV{'HTTP_REFERER'}."\n\n";

# Clean the server
if (int(rand(10)) == 1) {
  # expire old sessions
  $filez = "/tmp/*";
  while ($file = glob($filez)) {
    @stat=stat $file; 
    $days = (time()-$stat[9]) / (60*60*24);
    unlink $file if ($days > 3);
  }
}

exit(0);