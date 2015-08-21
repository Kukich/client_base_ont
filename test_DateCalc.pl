#!/usr/bin/perl

use strict;
use Test::More tests => 15;
use Data::Dumper;
use_ok('DateCalc');
my $massive = [
	['2013-11-24','100'],
	['2013-12-07','150'],
	['2013-12-30','200'],
];
my $make_range_result =  [[1,'2013-11-24','2013-12-03'],[2,'2013-12-04','2013-12-13'],[3,'2013-12-14','2013-12-23'],[4,'2013-12-24','2014-01-02'],[5,'2014-01-03','2014-01-12']];
my $calc_conv_period = [[1,'2013-11-24','2013-12-03',100],[2,'2013-12-04','2013-12-13',150],[3,'2013-12-14','2013-12-23',0],[4,'2013-12-24','2014-01-02',200],[5,'2014-01-03','2014-01-12',0]];
my $calc_conv_result = [[1,'2013-11-24','2013-12-03',100,'22.22'],[2,'2013-12-04','2013-12-13',150,'33.33'],[3,'2013-12-14','2013-12-23',0,'0.00'],[4,'2013-12-24','2014-01-02',200,'44.44'],[5,'2014-01-03','2014-01-12',0,'0.00']];
my $params ={
'delta_date' => [['2013-12-12','2013-12-12',0],['2013-12-12','2014-09-17',279],['2014-09-17','2013-12-12',-279]],
'add_delta_date' => [['2013-12-12',0,'2013-12-12'],['2013-12-12',279,'2014-09-17'],['2014-09-17',-279,'2013-12-12']],
'include_date' => [['2013-12-12','2013-12-12',1,'2013-12-12'],['2013-12-12','2014-12-12',1,'2014-09-17'],['2013-12-12','2014-07-17',0,'2014-09-15']],
'make_range' => [[$massive,10,$make_range_result],[$massive,0,0]],
'calc_conversion' => [[$calc_conv_period,450,$calc_conv_result]],
'get_periods' => [$massive,10,$calc_conv_result,450],
};

#delta_date add_delta_date include_date
foreach my $key (qw/delta_date add_delta_date include_date/){
	my $i=0;
	*FUNC = $DateCalc::{$key};
	foreach my $p (@{$params->{$key}}){
		$i++;
		is(*FUNC{CODE}($p->[0],$p->[1],$p->[3]),$p->[2],"$key $i");
	}
}
#make_range calc_conversion
foreach my $key (qw/make_range calc_conversion/){
	my $i=0;
	*FUNC = $DateCalc::{$key};
	foreach my $p (@{$params->{$key}}){
		$i++;
		is_deeply(*FUNC{CODE}($p->[0],$p->[1]),$p->[2],"$key $i");
	}
}
#get_periods
my ($got,$summ) = get_periods($params->{'get_periods'}->[0],$params->{'get_periods'}->[1]);
is_deeply($got,$params->{'get_periods'}->[2],"get_periods 1");
is($summ,$params->{'get_periods'}->[3],"get_periods 2");

