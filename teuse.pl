#!/usr/bin/env perl

# Simple IRC bot

use strict;
use warnings;
use 5.010;
use Bot::BasicBot;

package Teuse;
use base qw( Bot::BasicBot );

# @yops
my @yops = qw(yop plop bouga salutations! ahoy! enchantier!);
my $master = "matael";

sub said {
    my ($self, $a) = @_;

    # offend if in PM
    if ($a->{address} eq 'msg') {
       $self->say(
           who=>$a->{'who'},
           channel=>'msg', # answer privately
           body=>"FUCK OFF ! Parle en public si t'es un homme"
       );
    }
}

sub emoted {
    my ($self, $a) = @_;
    if ($a->{body} =~ /.*à|a soif.*/){
        $self->say(
            who=>$a->{who},
            channel => $a->{channel},
            body=>`python ./plugins/choix_boisson.py`
        );
    }
}

1;

my $teuse = Teuse->new(
	server => "irc.freenode.org",
	channels => ["#spi2011"],
	nick => 'teuse',
	charset=> "utf-8"
)->run();
