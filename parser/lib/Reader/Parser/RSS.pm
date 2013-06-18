package Reader::Parser::RSS;
use warnings;
use strict;

sub parse_header {
    my ($class, $xpath) = @_;

    # get all header <link>s
    my @links = map { $_->textContent } $xpath->findnodes('/rss/channel[1]/link');

    return {
        format      => 'rss',
        title       => $xpath->findvalue('/rss/channel[1]/title'),
        description => $xpath->findvalue('/rss/channel[1]/description'),
        updated     => $xpath->findvalue('/rss/channel[1]/pubDate'),
        links       => \@links,
        authors     => [],
    };
}

sub parse_items {
    my ($class, $xpath) = @_;

    my @items;
    my @item_nodes = $xpath->findnodes('/rss/channel[1]/item');
    foreach my $item_node (@item_nodes) {
        push @items, parse_item($xpath, $item_node);
    }

    return \@items;
}

sub parse_item {
    my ($xpath, $node) = @_;

    my @links = map { $_->textContent } $node->findnodes('./link');

    return {
        guid        => $node->findvalue('./guid'),
        title       => $node->findvalue('./title'),
        published   => $node->findvalue('./pubDate'),
        summary     => $node->findvalue('./description'),
        links       => \@links,
    };
}

1;
