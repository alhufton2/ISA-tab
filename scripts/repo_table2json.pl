#!/usr/local/bin/perl -w
use strict;
use Getopt::Long;

my $help = "usage: perl repo_table2json.pl [-t] -i input.csv > output.txt
-i [required] input filename
-t [optional] changes separator to tabs. Default is commas."; 

my $sep = ',';
my $use_tab;
my $input;

GetOptions(
    "t" => \$use_tab, # flag
    "i=s" => \$input
) or die "Bad options $!\n\n$help\n";

die "No file input$!\n\n$help\n\n" unless $input;

$sep = '\t' if $use_tab;


open (CSV, $input) or die "Could not open $input: $!";

while (<CSV>) {

    chomp;
    my @F = split(/$sep/);
    my @Fc = map { &cleaner($_) } @F;
    my $sep = '';
    $sep = ',' unless eof;     
    print <<EOF;
    {
       "name": "$Fc[0]",
       "value": "$Fc[1]",
       "\@type": "DataCatalog"
    }$sep
EOF
    
}

 
exit;

sub cleaner {
    my $string = shift;
    if ($string) {
        $string =~ s/"//g;
        $string =~ s/^\s+|\s+$//g;
        return $string;
    } else {
        return "";
    }
}



