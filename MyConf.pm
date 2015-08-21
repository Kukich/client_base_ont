package MyConf;
require Exporter;

@ISA       = qw(Exporter);
@EXPORT    = qw($database $user $password $host $data_source);

use strict;

our $database = "ont";
our $user = 'root';
our $password = '123456';
our $host = "http://localhost:8080";
our $data_source = "DBI:mysql:$database";

1;