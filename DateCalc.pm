#!/usr/local/bin/perl
package DateCalc;
use Exporter;           
@ISA =qw(Exporter);                                        
@EXPORT = qw(get_periods);

use Time::Local;
use POSIX qw(strftime);
use Data::Dumper;
use strict;


sub delta_date{
	my ($date1,$date2) = @_;
	$date1 =~ m/^(\d{4})-(\d{2})-(\d{2})$/;
	my $unix_time1 = timelocal(0, 0, 0, $3, $2-1, $1-1900);
	$date2 =~ m/^(\d{4})-(\d{2})-(\d{2})$/;
	my $unix_time2 = timelocal(0, 0, 0, $3, $2-1, $1-1900);
	my $unix_time = $unix_time2 - $unix_time1;
	return int($unix_time/86400);
}

sub add_delta_date{
	my ($date1,$delta) =@_;
	$date1 =~ m/^(\d{4})-(\d{2})-(\d{2})$/;
	my $unix_time1 = timelocal(0, 0, 0, $3, $2-1, $1-1900);
	my $unix_time2 = $unix_time1 + 86400*$delta + 7200;
	return strftime( "%Y\-%m\-%d", localtime($unix_time2));
}

sub include_date{
	my ($date1,$date2,$date) = @_;
	$date1 =~ m/^(\d{4})-(\d{2})-(\d{2})$/;
	my $unix_time1 = timelocal(0, 0, 0, $3, $2-1, $1-1900);
	$date2 =~ m/^(\d{4})-(\d{2})-(\d{2})$/;
	my $unix_time2 = timelocal(0, 0, 0, $3, $2-1, $1-1900);
	$date =~ m/^(\d{4})-(\d{2})-(\d{2})$/;
	my $unix_time = timelocal(0, 0, 0, $3, $2-1, $1-1900);
	return (($unix_time1<=$unix_time) && ($unix_time2>=$unix_time))?1:0;
}

sub make_range{
	my ($massive,$delta) = @_;
	return 0 if !$delta;
	my $start_date = $massive->[0]->[0];
	my $inc_date = $massive->[0]->[0];
	my $last_date = $massive->[-1]->[0];
	my $ranges;
	my $j=1;
	while (delta_date($inc_date,$last_date)>(-1)*$delta){
		my $end_date=add_delta_date($inc_date,$delta-1);
		push @$ranges,[$j,$inc_date,$end_date];
		$inc_date = add_delta_date($end_date,1);
		$j++;
	}
	return $ranges;
}

sub calc_conversion{
	my ($periods,$summ) = @_;
	my $conv_list;
	foreach my $el(@$periods){
		my $conver = 100 * ($el->[3]/$summ);
		push @$conv_list,[map{$_}@$el,sprintf("%.2f", $conver)];
	}
	return $conv_list;
}

sub get_periods{
	my ($massive,$delta) = @_;
	my $table;
	my $period_sum=0;
	my $periods;
	my $checked_range=0;
	my $summ=0;
	my $fh;
	my $ranges = make_range($massive,$delta);
	my $j=0;
	foreach my $el(@$massive){
		$j++;
		my $date = $el->[0];
		my $count = $el->[1];
		$summ += $count;
		foreach my $range(@$ranges){
			if ($checked_range >= $range->[0]){
				next;
			}
			elsif (include_date($range->[1],$range->[2],$date)){
				$period_sum += $count;
				#if element is last then we need to push it to the range
				if (scalar @$massive == $j){
					push @$periods,[$range->[0],$range->[1],$range->[2],$period_sum];
					$period_sum=0;
				}
				last;
			}else{
				push @$periods,[$range->[0],$range->[1],$range->[2],$period_sum];
				$checked_range = $range->[0];
				$period_sum = 0;
			}
		}
	}
	push @$periods,[$ranges->[-1]->[0],$ranges->[-1]->[1],$ranges->[-1]->[2],$period_sum];
	return calc_conversion($periods,$summ),$summ;
}

1;
