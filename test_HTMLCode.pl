#!/usr/bin/perl

use strict;
use Test::MockModule;
use Test::More tests => 5;

use_ok('HTMLCode');

my $module = new Test::MockModule('HTMLCode');

#-------------------------------------------------------------get_conversion_table START------------------------
my $clients_per_date = [
	['2013-11-24','100'],
	['2013-11-24','150'],
	['2013-12-30','200'],
	['2014-01-01','500'],
	['2014-01-24','120'],
	['2014-02-15','200'],
	['2014-03-22','300'],
	['2014-04-27','140'],
	['2014-05-01','150'],
	['2014-05-02','105'],
	['2014-05-03','195'],
	['2014-06-09','111'],
	['2014-06-27','95'],
	['2014-07-24','10'],
	['2014-11-24','20'],
	['2015-01-22','1'],
	['2015-02-17','300'],
];
my $correct_table_per_date = qq{<table border=1><tr><td>Number of period</td><td>From date to date period(10 days)</td><td>Count clients with status Registered</td><td>Conversion</td></tr><tr><td>1</td><td>from 2013-11-24 to 2013-12-03</td><td>250</td><td>9.27%</td></tr><tr><td>2</td><td>from 2013-12-04 to 2013-12-13</td><td>0</td><td>0.00%</td></tr><tr><td>3</td><td>from 2013-12-14 to 2013-12-23</td><td>0</td><td>0.00%</td></tr><tr><td>4</td><td>from 2013-12-24 to 2014-01-02</td><td>700</td><td>25.95%</td></tr><tr><td>5</td><td>from 2014-01-03 to 2014-01-12</td><td>0</td><td>0.00%</td></tr><tr><td>6</td><td>from 2014-01-13 to 2014-01-22</td><td>0</td><td>0.00%</td></tr><tr><td>7</td><td>from 2014-01-23 to 2014-02-01</td><td>120</td><td>4.45%</td></tr><tr><td>8</td><td>from 2014-02-02 to 2014-02-11</td><td>0</td><td>0.00%</td></tr><tr><td>9</td><td>from 2014-02-12 to 2014-02-21</td><td>200</td><td>7.42%</td></tr><tr><td>10</td><td>from 2014-02-22 to 2014-03-03</td><td>0</td><td>0.00%</td></tr><tr><td>11</td><td>from 2014-03-04 to 2014-03-13</td><td>0</td><td>0.00%</td></tr><tr><td>12</td><td>from 2014-03-14 to 2014-03-23</td><td>300</td><td>11.12%</td></tr><tr><td>13</td><td>from 2014-03-24 to 2014-04-02</td><td>0</td><td>0.00%</td></tr><tr><td>14</td><td>from 2014-04-03 to 2014-04-12</td><td>0</td><td>0.00%</td></tr><tr><td>15</td><td>from 2014-04-13 to 2014-04-22</td><td>0</td><td>0.00%</td></tr><tr><td>16</td><td>from 2014-04-23 to 2014-05-02</td><td>395</td><td>14.65%</td></tr><tr><td>17</td><td>from 2014-05-03 to 2014-05-12</td><td>195</td><td>7.23%</td></tr><tr><td>18</td><td>from 2014-05-13 to 2014-05-22</td><td>0</td><td>0.00%</td></tr><tr><td>19</td><td>from 2014-05-23 to 2014-06-01</td><td>0</td><td>0.00%</td></tr><tr><td>20</td><td>from 2014-06-02 to 2014-06-11</td><td>111</td><td>4.12%</td></tr><tr><td>21</td><td>from 2014-06-12 to 2014-06-21</td><td>0</td><td>0.00%</td></tr><tr><td>22</td><td>from 2014-06-22 to 2014-07-01</td><td>95</td><td>3.52%</td></tr><tr><td>23</td><td>from 2014-07-02 to 2014-07-11</td><td>0</td><td>0.00%</td></tr><tr><td>24</td><td>from 2014-07-12 to 2014-07-21</td><td>0</td><td>0.00%</td></tr><tr><td>25</td><td>from 2014-07-22 to 2014-07-31</td><td>10</td><td>0.37%</td></tr><tr><td>26</td><td>from 2014-08-01 to 2014-08-10</td><td>0</td><td>0.00%</td></tr><tr><td>27</td><td>from 2014-08-11 to 2014-08-20</td><td>0</td><td>0.00%</td></tr><tr><td>28</td><td>from 2014-08-21 to 2014-08-30</td><td>0</td><td>0.00%</td></tr><tr><td>29</td><td>from 2014-08-31 to 2014-09-09</td><td>0</td><td>0.00%</td></tr><tr><td>30</td><td>from 2014-09-10 to 2014-09-19</td><td>0</td><td>0.00%</td></tr><tr><td>31</td><td>from 2014-09-20 to 2014-09-29</td><td>0</td><td>0.00%</td></tr><tr><td>32</td><td>from 2014-09-30 to 2014-10-09</td><td>0</td><td>0.00%</td></tr><tr><td>33</td><td>from 2014-10-10 to 2014-10-19</td><td>0</td><td>0.00%</td></tr><tr><td>34</td><td>from 2014-10-20 to 2014-10-29</td><td>0</td><td>0.00%</td></tr><tr><td>35</td><td>from 2014-10-30 to 2014-11-08</td><td>0</td><td>0.00%</td></tr><tr><td>36</td><td>from 2014-11-09 to 2014-11-18</td><td>0</td><td>0.00%</td></tr><tr><td>37</td><td>from 2014-11-19 to 2014-11-28</td><td>20</td><td>0.74%</td></tr><tr><td>38</td><td>from 2014-11-29 to 2014-12-08</td><td>0</td><td>0.00%</td></tr><tr><td>39</td><td>from 2014-12-09 to 2014-12-18</td><td>0</td><td>0.00%</td></tr><tr><td>40</td><td>from 2014-12-19 to 2014-12-28</td><td>0</td><td>0.00%</td></tr><tr><td>41</td><td>from 2014-12-29 to 2015-01-07</td><td>0</td><td>0.00%</td></tr><tr><td>42</td><td>from 2015-01-08 to 2015-01-17</td><td>0</td><td>0.00%</td></tr><tr><td>43</td><td>from 2015-01-18 to 2015-01-27</td><td>1</td><td>0.04%</td></tr><tr><td>44</td><td>from 2015-01-28 to 2015-02-06</td><td>0</td><td>0.00%</td></tr><tr><td>45</td><td>from 2015-02-07 to 2015-02-16</td><td>0</td><td>0.00%</td></tr><tr><td>46</td><td>from 2015-02-17 to 2015-02-26</td><td>300</td><td>11.12%</td></tr><tr><td>46</td><td>from 2015-02-17 to 2015-02-26</td><td>0</td><td>0.00%</td></tr></table><br><div>Summ of registered clients : 2697</div>};
my $uncorrect_table_per_date = qq{<div>No clients in database with status Registered</div>};
my $i=0;
my $params = [[1,10,$correct_table_per_date],[0,10,$uncorrect_table_per_date]];
$module->mock('select_clients_per_date', sub {
 	my ($dbh,$status) = @_;
	if ($dbh){
		return $clients_per_date;
	}else{
		return "Error";
	}
});
foreach my $param(@$params){
	$i++;
	is(get_conversion_table($param->[0],$param->[1]),$param->[2],"get_conversion_table $i");
}

#-------------------------------------------------------------get_conversion_table END------------------------
#-------------------------------------------------------------get_table START---------------------------------
my $clients = [
	[1,'aa','111-11-11','New','2013-11-24'],
	[2,'ab','111-11-11','Registered','2013-11-24'],
	[3,'ac','111-11-11','Registered','2013-12-30'],
	[4,'ad','111-11-11','Refused','2014-01-01'],
	[5,'af','111-11-11','New','2014-01-24'],
	[6,'ag','111-11-11','Registered','2014-02-15'],
	[7,'ah','111-11-11','Registered','2014-03-22'],
	[8,'aj','111-11-11','Refused','2014-04-27'],
	[9,'ak','111-11-11','New','2014-05-01'],
	[10,'la','111-11-11','Registered','2014-05-02'],
	[11,'aq','111-11-11','Registered','2014-05-03'],
	[12,'aw','111-11-11','New','2014-06-09'],
	[13,'ae','111-11-11','Registered','2014-06-27'],
	[14,'ar','111-11-11','Refused','2014-07-24'],
	[15,'at','111-11-11','New','2014-11-24'],
	[16,'ay','111-11-11','Unavailable','2015-01-22'],
	[17,'aa','111-11-11','Unavailable','2015-02-17'],
];

my $correct_table =qq{<form action="/main.cgi" method="GET"><input type="hidden" name="type" value="update"><table border=1><tr><td>Choose id to update </td><td>Name</td><td>Phone Number</td><td>Status</td><td>Date</td></tr><tr><td><input type="radio" name="id" value="1"> 1</td><td>aa</td><td>111-11-11</td><td>New</td><td>2013-11-24</td></tr><tr><td><input type="radio" name="id" value="2"> 2</td><td>ab</td><td>111-11-11</td><td>Registered</td><td>2013-11-24</td></tr><tr><td><input type="radio" name="id" value="3"> 3</td><td>ac</td><td>111-11-11</td><td>Registered</td><td>2013-12-30</td></tr><tr><td><input type="radio" name="id" value="4"> 4</td><td>ad</td><td>111-11-11</td><td>Refused</td><td>2014-01-01</td></tr><tr><td><input type="radio" name="id" value="5"> 5</td><td>af</td><td>111-11-11</td><td>New</td><td>2014-01-24</td></tr><tr><td><input type="radio" name="id" value="6"> 6</td><td>ag</td><td>111-11-11</td><td>Registered</td><td>2014-02-15</td></tr><tr><td><input type="radio" name="id" value="7"> 7</td><td>ah</td><td>111-11-11</td><td>Registered</td><td>2014-03-22</td></tr><tr><td><input type="radio" name="id" value="8"> 8</td><td>aj</td><td>111-11-11</td><td>Refused</td><td>2014-04-27</td></tr><tr><td><input type="radio" name="id" value="9"> 9</td><td>ak</td><td>111-11-11</td><td>New</td><td>2014-05-01</td></tr><tr><td><input type="radio" name="id" value="10"> 10</td><td>la</td><td>111-11-11</td><td>Registered</td><td>2014-05-02</td></tr><tr><td><input type="radio" name="id" value="11"> 11</td><td>aq</td><td>111-11-11</td><td>Registered</td><td>2014-05-03</td></tr><tr><td><input type="radio" name="id" value="12"> 12</td><td>aw</td><td>111-11-11</td><td>New</td><td>2014-06-09</td></tr><tr><td><input type="radio" name="id" value="13"> 13</td><td>ae</td><td>111-11-11</td><td>Registered</td><td>2014-06-27</td></tr><tr><td><input type="radio" name="id" value="14"> 14</td><td>ar</td><td>111-11-11</td><td>Refused</td><td>2014-07-24</td></tr><tr><td><input type="radio" name="id" value="15"> 15</td><td>at</td><td>111-11-11</td><td>New</td><td>2014-11-24</td></tr><tr><td><input type="radio" name="id" value="16"> 16</td><td>ay</td><td>111-11-11</td><td>Unavailable</td><td>2015-01-22</td></tr><tr><td><input type="radio" name="id" value="17"> 17</td><td>aa</td><td>111-11-11</td><td>Unavailable</td><td>2015-02-17</td></tr></table>Choose status for selected client <select name ="status"><option name ="status" value="New" selected>New<option name ="status" value="Registered" >Registered<option name ="status" value="Refused" >Refused<option name ="status" value="Unavailable" >Unavailable</select> <input type="submit" value="Update status"></form>};
my $uncorrect_table =qq{<div>No clients in database</div>};

$module->mock('select_clients', sub {
 	my ($dbh,$status) = @_;
	if ($dbh){
		return $clients;
	}else{
		return "Error";
	}
});
my $params = [[1,$correct_table],[0,$uncorrect_table]];
my $i=0;
foreach my $param(@$params){
	$i++;
	is(get_table($param->[0]),$param->[1],"get_table $i");
}
#-------------------------------------------------------------get_table END-----------------------------------