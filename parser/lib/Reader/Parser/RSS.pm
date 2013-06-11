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

sub parse_items {
    my ($class, $xpath) = @_;

    my @items;
    my $item_nodeset = $xpath->find('/rss/channel[1]/item');
    foreach my $item_context ($item_nodeset->get_nodelist) {
        push @items, parse_item($xpath, $item_context);
    }

    return \@items;
}

sub parse_item {
    my ($xpath, $context) = @_;

    my $link_nodeset = $xpath->find('./link', $context);
    my @links = map { $_->string_value } $link_nodeset->get_nodelist;

    return {
        title       => $xpath->find('./title', $context)->string_value,
        published   => $xpath->find('./pubDate', $context)->string_value,
        summary     => $xpath->find('./description', $context)->string_value,
        links       => \@links,
    };
}

1;
