#!/usr/bin/env perl

# Just trying to implement a simple IRC
# bot over ii.

use strict;
use warnings;
use 5.010;
use IO::File;

# Configuration
my $irc_dir = '/home/matael/irc';
my $host = 'irc.freenode.net';
my $chan = '#spi2011';
my $nick = 'test_ii';

my $path = "$irc_dir/$host/$chan";
my $path_out = "$path/in"; 
my $path_in = "$path/out"; 

my $in=IO::File->new($path_in, "<")
    or die "Error opening in file : $!\n";

my @old_log = $in-> getlines;
undef @old_log;

my @seen;
push @seen, $nick;
my $line;

my %actions = (
	qr/[^<]*<([^>]*)>.*/ => sub { say $1}
);

my @acts = keys %actions;

while (1) {
    $line = $in->getline;
    if (defined $line) {
        if ($line =~ $acts[0]){
            $actions{$acts[0]}->();
        }
        if ($line =~ m/[^>]*$nick:? casse toi.*/) {
            $in->close();
            exit 0;
        }
        if ($line =~ m/[^>]* *lol.*/) { 
            IRCsend('Yeah !');
        }
    }
}

sub IRCsend {
    my ($message) = @_;
    my $out=IO::File->new($path_out, ">" )
        or die "Error opening out file : $!\n"; # /!\ we'll write here
    $out->print("$message\n");
    $out->close();
}
