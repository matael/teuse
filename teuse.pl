#!/usr/bin/env perl

# Simple IRC bot

use strict;
use warnings;
use 5.010;
use Bot::BasicBot;
use LWP::Simple;
use LWP::UserAgent;
use JSON;
use Redis;

package Teuse;
use base qw( Bot::BasicBot );

# @yops
my @yops = qw(
	yop
	plop
	bouga
	ahoy
	salut
	ahoy!
	enchantier!
	salut!
	salutations!
	);
my @meh = (
   'va chier !',
   'gné ?',
   'may be...',
   'et ta soeur !',
   "le poulet, c'est bon",
   'thx !',
   'youpi !',
   'pelle',
   'un chameau est un dromadaire presque partout'
   );

#variable pour dire bonne nuit quand un utilisateur s'en va. Variable to wish good night when an user quit
my @nuit = (
    'Bonsoir!',
    'bonsoir',
    'Bonne nuit!',
    '\'ne nuit!'
    );

my $master = "matael";
my $redis_db = 3;
my $redis_prefix = "teuse:";

# Does teuse must answer to everything ?
my $talk = 1;

sub said {
    my ($self, $a) = @_;

	# Talk or not ;) {{{
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
	# }}}

    # offend if in PM {{{
    if ($a->{address} and $a->{address} eq 'msg') {
       $self->say(
           who=>$a->{'who'},
           channel=>'msg', # answer privately
           body=>"FUCK OFF ! Parle en public si t'es un homme"
       );
	   return;
    }
	# }}}

	# matael.org {{{
	if ($a->{body} =~ /.*\[~([^\/]*)\/([^\]]*)\].*/) {
		$self->say(
			channel => $a->{channel},
			body => "Check http://matael.org/~$1/$2"
		);
	}
	# }}}

	# yops {{{
	elsif ($talk and $a->{body} =~ /.*(yop?|bouga|salut|salutations?|morning|a?hoy|plop)(\W|$).*/i) {
		my $i = rand @yops;
		$self->say(
			who => $a->{who},
			channel => $a->{channel},
			body => $yops[$i]
		);
	}
	# }}}

	# meh {{{
	elsif ($talk and $a->{body} =~ /\Wteuse\W/i) {
		my $i = rand @meh;
		$self->say(
			who => $a->{who},
			channel => $a->{channel},
			body => $meh[$i]
		);
	}
	# }}}

    #re{{  Une condition pour repondre re a un utilisateur. A condition to answer 're' to an user
    elsif($talk and $a->{body} =~ /\Wre\W/i) {
		$self->say(
			who => $a->{who},
			channel => $a->{channel},
			body => "re",
		);
    }
    #}}

    # Soir{{ Une condition pour dire bonne nuit. A condition to wish 'good night/good evening'
    elsif($talk and $a->{body} =~ /.*(bonsoir|'ne nuit|bonne nuit).*/i) {
        my $i = rand @nuit;
		$self->say(
			who => $a->{who},
			channel => $a->{channel},
			body => $nuit[$i]
		);
    }
 
	# pong {{{
	elsif ($talk and $a->{body} =~ /^ping$/i) {
		$self->auto_kick($a->{who}, $a->{channel});
		$self->say(
			who => $a->{who},
			channel => $a->{channel},
			body => "pong",
		);
	}
	# }}}


	# cookie {{{
	elsif ($talk and $a->{body} =~ /.*cookie.*/) {
		$self->auto_kick($a->{who}, $a->{channel});
		$self->say(
			channel => $a->{channel},
			body => "Owi ! \\o/"
		);
	}
	# }}}

	# \o/ {{{
	elsif ($talk and $a->{body} =~ m#((\\|/)o(\\|/))#) {
		$self->auto_kick($a->{who}, $a->{channel});
		$self->say(
			channel => $a->{channel},
			body => $1
		);
	}
	# }}}

	# pastebin {{{
	elsif ($a->{body} =~ /.*past(er?|ai(s|t|ent)).*/) {
		$self->say(
			channel => $a->{channel},
			body => 'http://pastebin.archlinux.fr/'
		);
	}
	# }}}

	# fusion {{{
	elsif ($a->{body} =~ /!f+u+s+i+o+n+\W*/) {
		$self->auto_kick($a->{who}, $a->{channel});
		$self->say(
			channel => $a->{channel},
			body => '/o/............'
		);
		$self->say(
			channel => $a->{channel},
			body => '............\o\\'
		);
		$self->say(
			channel => $a->{channel},
			body => '../o/......\o\..'
		);
		$self->say(
			channel => $a->{channel},
			body => "FUUUUUUUSIIIIOOOOONNNNN !"
		);
		$self->say(
			channel => $a->{channel},
			body => '...../o/\o\.....'
		);
		$self->say(
			channel => $a->{channel},
			body => '*CRONK*'
		);
	}
	# }}}

	# quotes {{{
	elsif ($a->{body} =~ /^!quotes\s+(.*)$/) {
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
		} elsif ($1 =~ /\W*add\s([^\s]*)\s(.*)$/) {
			# request to links.matael.org
			my $ua = LWP::UserAgent->new();
			my $author = $1;
			my $quote = $2;

			my $response = $ua->post("http://quotes.matael.org/",
				[
					author => $author,
					quote => $quote
				]
			);
			my $msg;
			if ($response->is_error) {
				$msg = "Arf... y'a un blem.... $master ? Un coup de main ?";
			} else {
				$msg = "Yes !!";
			}

			$self->say(
				who => $a->{who},
				channel => $a->{channel},
				body => $msg
			);
		} else {
			$self->say(
				who => $a->{who},
				channel => $a->{channel},
				body => `python plugins/insulte.py`
			);
		}
	}
	# }}}

	# links {{{
	elsif ($a->{body} =~ /^!lk\s+(.*)$/) {
		 if ($1 =~ /([^\s]*)(\s.*)?$/) {
			# request to links.matael.org
			my $ua = LWP::UserAgent->new();
			my $url = $1;
			my $title = $url;
			$title = $2 if ($2);

			my $response = $ua->post("http://links.matael.org/new",
				[
					url => $url,
					title => $title,
					poster => $a->{who}
				]
			);
			my $msg;
			if ($response->is_error) {
				$msg = "Arf... y'a un blem.... $master ? Un coup de main ?";
			} else {
				$msg = "Yes !!";
			}

			$self->say(
				who => $a->{who},
				channel => $a->{channel},
				body => $msg
			);
		elsif ($1 =~ /([^\s]*)\s*$/) {
			if ($1 eq 'random') {
				my $lk = LWP::Simple::get("http://links.matael.org/api/random");
				$self->say(
					who => $a->{who},
					channel => $a->{channel},
					body => $lk
				);
			} elsif ($1 eq 'last') {
				my $lk = LWP::Simple::get("http://links.matael.org/api/api");
				$self->say(
					who => $a->{who},
					channel => $a->{channel},
					body => $lk
				);
			} else {
				$self->say(
					who => $a->{who},
					channel => $a->{channel},
					body => "Désolé, ça ne me dit rien."
				);
			}
		} else {
			$self->say(
				who => $a->{who},
				channel => $a->{channel},
				body => "Normalement c'est comme ça :"
			);
			$self->say(
				channel => $a->{channel},
				body => "!link URL [titre]"
			);
			$self->say(
				channel => $a->{channel},
				body => "pour la liste des liens : http://links.matael.org"
			);
		}
	}
	# }}}

	# One above one (thx @halfr) {{{#{{{#}}}
	elsif ($talk and $a->{body} =~ /(\+1)|(plus\sun\W*$)|(je\splussoie?t?s?)/) {
		$self->auto_kick($a->{who}, $a->{channel});
		my $conn = Redis->new();
		$conn->select($redis_db);
		my $count = $conn->incr($redis_prefix.'one_above_one');
		$conn->quit;
		$self->say(
			channel => $a->{channel},
			body => $count
		);
	}
	# }}}


	#############################
	# pelle teuse {{{
	if ($talk and $a->{body} =~ /[^>]*.*p+e+l{2,}e+\W*$/) {
		$self->say(
			channel => $a->{channel},
			body => "teuse"
		);
	}
	# }}}

	#############################
	# quit {{{
	if ($a->{who} eq $master and ($a->{body} eq "casse toi" or $a->{body} eq "dehors !") and $a->{address}){
		$self->shutdown($self->quit_message());
	}
	# }}}
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

sub auto_kick {
	my ($self, $target_nick, $channel) = @_;

	if ($target_nick ne $master) {

		my $conn = Redis->new();
		$conn->select($redis_db);
		if (!$conn->get($redis_prefix.$target_nick)) {
			$conn->setex($redis_prefix.$target_nick, 180, 0);
		}
		my $count = $conn->incr($redis_prefix.$target_nick);
		if (int($count) > 5+int(rand(7))) {
			$self->kick($channel, $target_nick, 'ET VLAN !');
			$conn->del($redis_prefix.$target_nick);
		}
	}
}

1;

my $teuse = Teuse->new(
	server => "irc.freenode.org",
	channels => ["#spi2011"],
	nick => 'teuse',
	charset=> "utf-8",
	quit_message => "Oui maître..."
)->run();
