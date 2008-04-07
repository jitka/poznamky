#!/usr/bin/perl
use warnings;
use strict;

my %vars = ( '$' => '$' );

sub handle( $ ) {
	my( $inp ) = @_;
	foreach( @{$inp} ) {
		if( s/^#// ) {
			chomp;
			s/\$\(([^()])\)/$vars{$1}/g;
			if( /^(\w)+\s*:=(.*)/ ) {
				$vars{$1} = $2;
			} elsif( /^include\s+(.*\S)\s*$/ ) {
				open F, $1 or die "Could not include $1\n";
				my @input = <F>;
				&handle( \@input );
				close F;
			} else {
				print $_."\n";
			}
		} else {
			print;
		}
	}
}

my @input = <STDIN>;
handle( \@input );
