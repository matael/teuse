use strict;
use warnings;
use 5.010;
use MediaWiki::API;

my $api = MediaWiki::API->new();
$api->{config}->{api_url} = "http://fr.wikipedia.org/w/api.php";

my $page_name = "RSS";
my $page = $api->get_page({title=>$page_name});

$page->{'*'} =~ s/([^\([\|\{]+.*)//;
print $page->{'*'};
