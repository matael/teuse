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
    if ($a->{address} and $a->{address} eq 'msg') {
       $self->say(
           who=>$a->{'who'},
           channel=>'msg', # answer privately
           body=>"FUCK OFF ! Parle en public si t'es un homme"
       );
	   return;
    }

	# matael.org
	if ($a->{body} =~ /.*\[~([^\/]*)\/([^\]]*)\].*/) {
		$self->say(
			channel => $a->{channel},
			body => "Check http://matael.org/~$1/$2"
		);
	}

	# yops
	elsif ($a->{body} =~ /.*(yop?|bouga|morning|ahoy|plop).*/ ) {
		my $i = rand @yops;
		$self->say(
			who => $a->{who},
			channel => $a->{channel},
			body => $yops[$i]
		);
	}

	# cookie
	elsif ($a->{body} =~ /.*cookie.*/) {
		$self->say(
			channel => $a->{channel},
			body => "Owi ! \\o/"
		);
	}
	
	# pastebin
	elsif ($a->{body} =~ /.*paste\W.*/) {
		$self->say(
			channel => $a->{channel},
			body => 'http://pastebin.archlinux.fr/'
		);
	}

	#############################
	# pelle teuse
	if ($a->{body} =~ /[^>]*.*p+e+l{2,}e+\W*$/) {
		$self->say(
			channel => $a->{channel},
			body => "teuse"
		);
	}

	#############################
	# quit
	if ($a->{who} eq $master and $a->{body} eq "casse toi" and $a->{address}){
	$self->say(
	channel => $a->{channel},
	body => "Oui Maitre..."
	);
	exit(0);
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
