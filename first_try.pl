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
my $nick = 'teuse';

my $msg_presentation = "Salut, je m'appelle teuse. En fait, je suis son petit frère, teuse est morte. Elle était en Python et je suis en Perl ;)";

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

my @yops = qw(yop plop salutations! ahoy!);
my @meh = ('gné ?', 'va chier !', 'may be...', 'et ta soeur !', 'le poulet, c\'est bon', 'thx !');

my %actions = (
    #qr/[^<]*<([^>]*)>.*/ => sub { say $1},
	qr/[^>]*$nick:? casse toi.*/ => sub { $in->close(); exit 0;},
    qr/[^>]*.*(yop|morning|ahoy|plop).*/ => sub { my $i = rand @yops; IRCsend($yops[$i]); },
    qr/[^>]*[^$nick\s*:?].*$nick.*/ => sub { my $i = rand @yops; IRCsend($meh[$i]); },
	qr/[^>]*$nick:?.* qui es tu.*/ => sub { IRCsend($msg_presentation);},
    qr/[^>]* \[Exo::([^\]]*)\].*/ => sub { IRCsend("Check http://exos.matael.org/?n=$1"); }
);


while (1) {
    $line = $in->getline;
    if (defined $line and !($line =~ m/<$nick>/)) {
        foreach my $reg (keys %actions) {
            if ($line =~ $reg){
                $actions{$reg}->();
            }
        }
    }
}

# subroutine to send msgs
sub IRCsend {
    my ($message) = @_;
    my $out=IO::File->new($path_out, ">" )
        or die "Error opening out file : $!\n"; # /!\ we'll write here
    $out->print("$message\n");
    $out->close();
}


# vim: set ts=4 sw=4 et autoindent:
