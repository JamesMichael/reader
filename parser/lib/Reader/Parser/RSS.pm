package Reader::Parser::RSS;
use warnings;
use strict;

sub parse_header {
    my ($class, $xpath) = @_;

    # get all header <link>s
    my $link_nodeset = $xpath->find('/rss/link');
    my @links = map { $_->string_value } $link_nodeset->get_nodelist;

    return {
        format      => 'rss',
        title       => $xpath->getNodeText('/rss/channel[1]/title')->value,
        description => $xpath->getNodeText('/rss/channel[1]/description')->value,
        updated     => $xpath->getNodeText('/rss/channel[1]/pubDate')->value,
        links       => \@links,
        authors     => [],
    };
}

1;
