#!/usr/bin/perl
package Utils;
use Exporter;           
@ISA =qw(Exporter);                                        
@EXPORT = qw(check_params);

my $FIELD_FORMAT={
'phone' => sub {$_[0] =~ /^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$/s},
'date' => sub {$_[0] =~ /^[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|1[0-9]|2[0-9]|3[01])$/s},
'status' => sub {$_[0] =~ /^new|registered|refused|unavailable$/is},
'delta' => sub {$_[0] =~ /^([1-9]{1})|([0-9]{2,})$/},
};

my %IMP_PARAMS=(
'insert' => [name,phone,date,status],
'update' => [id,status],
'conversion' => [delta],
);

sub check_params{
	my ($cgi,$type) = @_;
	my @err;
	foreach my $key (@{$IMP_PARAMS{$type}}){
		push @err,"No input param $key" if ((!defined $cgi->param($key)) || (!$cgi->param($key)));
		if ((exists $FIELD_FORMAT->{$key})&&($cgi->param($key))){
			push @err,"Wrong format of $key" unless &{$FIELD_FORMAT->{$key}}($cgi->param($key));
		}
	}
	return \@err;
}
1;