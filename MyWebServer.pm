package MyWebServer;

use base HTTP::Server::Simple::CGI;
use strict;
use HTMLCode qw(get_insert_form get_table error get_conversion_table get_delta_form);
use DBI;
use DBD::mysql;
use Data::Dumper;
use Utils qw(check_params);
use MyConf qw($database $user $password $host $data_source);

my %dispatch = (
    '/main.cgi' => \&main_page,
    '/second.cgi' =>\&second_page,
);

sub handle_request {
    my $self = shift;
    my $cgi  = shift;
  
    my $path = $cgi->path_info();
    my $handler = $dispatch{$path};

    if (ref($handler) eq "CODE") {
        print "HTTP/1.0 200 OK\r\n";
        $handler->($cgi);
        
    } else {
        print "HTTP/1.0 404 Not found\r\n";
        print $cgi->header,
              $cgi->start_html('Not found'),
              $cgi->h1('Not found'),
              $cgi->end_html;
    }
}

sub main_page{
	my $cgi = shift;
	my $err;
	my $ext;
	return if !ref $cgi;
	my $dbh = DBI->connect("DBI:mysql:$database", $user, $password) or die "Unable to connect: $DBI::errstr\n";
	my $html;
	my $type = $cgi->param('type');
	if ($type eq 'insert'){
		 $err=Utils::check_params($cgi,$type);
		 if (scalar @$err == 0){
			$ext = HTMLCode::insert_data($dbh,$cgi);
		 }else{
			$ext = HTMLCode::error($err);
		}
	}elsif($type eq 'update'){
		$err=Utils::check_params($cgi,$type);
		if (scalar @$err == 0){
			$ext = HTMLCode::update_data($dbh,$cgi);
		}else{
			$ext = HTMLCode::error($err);
		}
	}
	my $table = HTMLCode::get_table($dbh);
	my $form = HTMLCode::get_insert_form;
	$html .= $table ."<br>". $form;
	my $href = qq{<br><a href="/second.cgi?delta=10">URL for second page (conversion)</a>};
	$dbh->disconnect;
	print $cgi->header,
          $cgi->start_html("Main Page"),
		  $ext,
          $html,
		  $href,
          $cgi->end_html;
}

sub second_page{
	my $cgi = shift;
	my ($err,$ext,$html);
	return if !ref $cgi;
	my $dbh = DBI->connect("DBI:mysql:$database", $user, $password) or die "Unable to connect: $DBI::errstr\n";
	$err=Utils::check_params($cgi,'conversion');
	if (scalar @$err == 0){
		$ext = HTMLCode::get_conversion_table($dbh,$cgi->param('delta'));
	}else{
		$ext = HTMLCode::error($err);
	}
	$ext .= HTMLCode::get_delta_form;
	my $href = qq{<br><a href="/main.cgi">URL for first page (table with clients)</a>};
	$dbh->disconnect;
	print $cgi->header,
          $cgi->start_html("Second Page"),
		  $ext,
          $html,
		  $href,
          $cgi->end_html;
}
1;