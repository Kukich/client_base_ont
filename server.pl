#!/usr/bin/perl
# start the server on port 8080
use base HTTP::Server::Simple::CGI;
use MyWebServer;
my $pid = MyWebServer->new(8080)->background();
