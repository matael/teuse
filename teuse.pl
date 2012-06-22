#!/usr/bin/env perl

# Simple IRC bot

use strict;
use warnings;
use 5.010;
use Bot::BasicBot;
use LWP::Simple;
use JSON;

package Teuse;
use base qw( Bot::BasicBot );

# @yops
my @yops = qw(yop plop bouga salutations! ahoy! enchantier!);
my $master = "matael";

# Does teuse must answer to everything ?
my $talk = 1;

sub said {
    my ($self, $a) = @_;

	if ($a->{who} eq $master and $a->{body} eq "!talk") {
		if ($talk) {
			$self->say(
				channel=>$a->{channel},
				body=>"ok ok... je me tais"
			);
			$talk = 0;
		} else {
			$self->say(
				channel=>$a->{channel},
				body=>"back to life !! \\o/"
			);
			$talk = 1;
		}

	}

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
	elsif ($talk and $a->{body} =~ /.*(yop?|bouga|morning|a?hoy|plop)(\W|$).*/i) {
		my $i = rand @yops;
		$self->say(
			who => $a->{who},
			channel => $a->{channel},
			body => $yops[$i]
		);
	}

	# cookie
	elsif ($talk and $a->{body} =~ /.*cookie.*/) {
		$self->say(
			channel => $a->{channel},
			body => "Owi ! \\o/"
		);
	}

	elsif ($talk and $a->{body} =~ m#((\\|/)o(\\|/))#) {
		$self->say(
			channel => $a->{channel},
			body => $1
		);
	}
	
	# pastebin
	elsif ($a->{body} =~ /.*past(er?|ai(s|t|ent)).*/) {
		$self->say(
			channel => $a->{channel},
			body => 'http://pastebin.archlinux.fr/'
		);
	}

	# quotes
	elsif ($a->{body} =~ /^!quotes\s(.*)$/) {
		if ($1 =~ /\W*random$/) {
			# request to quotes.matael.org
			my $res = JSON::from_json(LWP::Simple::get("http://quotes.matael.org/api/random"));
			$self->say(
				who => $a->{who},
				channel => $a->{channel},
				body => "$res->{author} dit un jour : \"$res->{quote}\""
			);
		} elsif ($1 =~ /\W*top$/) {
			# request to quotes.matael.org
			my $res = JSON::from_json(LWP::Simple::get("http://quotes.matael.org/api/top"));
			my $votes = $res->{vote_up}-$res->{vote_down};
			$self->say(
				who => $a->{who},
				channel => $a->{channel},
				body => "$res->{author} domine avec $votes votes pour avoir dit \"$res->{quote}\""
			);
		} elsif ($1 =~ /\W*last$/) {
			# request to quotes.matael.org
			my $res = JSON::from_json(LWP::Simple::get("http://quotes.matael.org/api/last"));
			my $votes = $res->{vote_up}-$res->{vote_down};
			$self->say(
				who => $a->{who},
				channel => $a->{channel},
				body => "La derniere en date est de $res->{author} avec \"$res->{quote}\""
			);
		} else {
			$self->say(
				who => $a->{who},
				channel => $a->{channel},
				body => "Euh... je crois qu'y a gourance !"
			);
		}
	}

	#############################
	# pelle teuse
	if ($talk and $a->{body} =~ /[^>]*.*p+e+l{2,}e+\W*$/) {
		$self->say(
			channel => $a->{channel},
			body => "teuse"
		);
	}

	#############################
	# quit
	if ($a->{who} eq $master and $a->{body} eq "casse toi" and $a->{address}){
		$self->shutdown($self->quit_message());
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
