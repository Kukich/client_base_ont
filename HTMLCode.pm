package HTMLCode;

use Clients qw(select_clients insert_client update_client_status select_clients_per_date);
use DateCalc qw(get_periods);
use MyConf qw($host);
use Exporter; 
@ISA =qw(Exporter);                                                  
@EXPORT = qw(get_insert_form get_table error get_conversion_table get_delta_form);


our $INSERT_FORM =qq{
<table>
<form action="$host/main.cgi" method="GET">
<tr><td>Insert name</td><td><input type="text" name="name"></td></tr>
<tr><td>Insert phone number</td><td><input type="text" name="phone"></td></tr>
<tr><td>Status</td><td><select name ="status">
<option name ="status" value="New" selected>New
<option name ="status" value="Registered">Registered
<option name ="status" value="Refused">Refused
<option name ="status" value="Unavailable">Unavailable
</select></td></tr>
<tr><td>Insert date</td><td><input type="text" name="date" value="yyyy-mm-dd"></td></tr>
<tr><td><input type="submit" value="Add user"></td></tr>
<input type="hidden" name="type" value="insert">
</form>
</table>
};

sub get_table{
	my $dbh = shift;
	my $clients = select_clients($dbh,"id");
	my $table;
	if (scalar @$clients > 0){
		$table =qq{<form action="/main.cgi" method="GET"><input type="hidden" name="type" value="update"><table border=1><tr><td>Choose id to update </td><td>Name</td><td>Phone Number</td><td>Status</td><td>Date</td></tr>};
		foreach my $client (@$clients){
			$table .= "<tr><td>".get_radio_button($client->[0])."</td><td>".$client->[1]."</td><td>".$client->[2]."</td><td>".$client->[3]."</td><td>".$client->[4]."</td></tr>";
		}
		$table .= qq{</table>Choose status for selected client };
		$table .= get_status_select_form();
		$table .=qq{ <input type="submit" value="Update status"></form>};
	}else{
		$table = qq{<div>No clients in database</div>};
	}
	return $table;
}

sub get_conversion_table{
	my ($dbh,$delta) = @_;
	my $data = select_clients_per_date($dbh,'Registered');
	if (scalar @$data <= 0){
		return qq{<div>No clients in database with status Registered</div>};
	}
	my ($conv_arr,$summ) = get_periods($data,$delta);
	my $table = qq{<table border=1><tr><td>Number of period</td><td>From date to date period($delta days)</td><td>Count clients with status Registered</td><td>Conversion</td></tr>};
	foreach my $el(@$conv_arr){
		$table .= "<tr><td>".$el->[0]."</td><td>from ".$el->[1]." to ".$el->[2]."</td><td>".$el->[3]."</td><td>".$el->[4]."%</td></tr>";
	}
	$table .= qq{</table><br><div>Summ of registered clients : $summ</div>};
	return $table;
}

sub insert_data{
	my ($dbh,$cgi) = @_;
	my $code = insert_client($dbh,$cgi->param('name'),$cgi->param('phone'),$cgi->param('status'),$cgi->param('date'));
	return $code eq '1' ? '' : error($code); 
}

sub update_data{
	my ($dbh,$cgi) = @_;
	my $code = update_client_status($dbh,$cgi->param('id'),$cgi->param('status'));
	return $code eq '1' ? '' : error($code);
}

sub get_status_select_form{
	my $html=q{<select name ="status">};
	for (qw/New Registered Refused Unavailable/){
		$html .= qq{<option name ="status" value="$_" };
		$html .= ($_ eq 'New') ? 'selected': '';
		$html .= ">$_";
	}
	$html.="</select>";
	return $html;
}

sub get_insert_form{
	return $INSERT_FORM;
}

sub get_delta_form{
	return qq{<form action="$host/second.cgi" method="GET"><table><tr><td>Insert period delta (days) for conversion</td><td><input type="text" name="delta"></td><td><input type="submit" value="Count conversion"></td></tr></table></form>};
}

sub get_radio_button{
	my $id = shift;
	return qq{<input type="radio" name="id" value="$id"> $id};
}

sub error{
	my $err = shift;
	my $html = '<p style="color:red">';
	$err = [$err] if ref $err ne 'ARRAY';
	$html .= join ("<br>",@$err);
	$html .= "</p>";
	return $html;
}
1;
