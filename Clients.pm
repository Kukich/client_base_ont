package Clients;
use Exporter;           
@ISA =qw(Exporter);                                        
@EXPORT = qw(select_clients insert_client update_client_status select_clients_per_date);
use DBI;
use DBD::mysql;
use Data::Dumper;


sub select_clients{
	my ($dbh,$order_by) = @_;
	my $query = "select id,name,phone,status,i_date from clients ";
	$query .= "order by $order_by" if $order_by;
	my $sth = $dbh->prepare($query) ;
	$sth->execute or return $dbh->errstr;
	return $sth->fetchall_arrayref;
}

sub select_clients_per_date{
	my ($dbh,$status) = @_;
	my $query = "select i_date,count(id) from clients where status=? group by i_date";
	my $sth = $dbh->prepare($query) ;
	$sth->execute($status) or return $dbh->errstr;
	return $sth->fetchall_arrayref;
}

sub insert_client{
	my ($dbh,$name,$phone,$status,$date ) = @_;
	my $query = "insert into clients (name,phone,status,i_date) values(?,?,?,?)";
	my $sth = $dbh->prepare ($query);
	$sth->execute($name,$phone,$status,$date) or return $dbh->errstr;	
	return 1;
}

sub update_client_status{
	my ($dbh,$id,$status) = @_;
	my $query = "update clients set status = ? where id = ?";
	my $sth = $dbh->prepare ($query);
	$sth->execute($status,$id) or  return $dbh->errstr;
	return 1;
}
1;