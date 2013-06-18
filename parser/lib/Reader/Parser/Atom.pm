package Reader::Parser::Atom;
use warnings;
use strict;

sub parse_header {
    my ($class, $xpath) = @_;

    # get all author names
    my @authors = map { $_->textContent } $xpath->findnodes('/atom:feed/atom:author/atom:name');

    # get all header <link> href, except those with rel=self
    my @links = map { $_->textContent } $xpath->findnodes('/atom:feed/atom:link[@rel!="self"]/@href');

    return {
        format      => 'atom',
        title       => $xpath->findvalue('/atom:feed/atom:title'),
        description => $xpath->findvalue('/atom:feed/atom:subtitle'),
        updated     => $xpath->findvalue('/atom:feed/atom:updated'),
        links       => \@links,
        authors     => \@authors,
    };
}

sub parse_items {
    my ($class, $xpath) = @_;

    my @items;
    my @item_nodes = $xpath->findnodes('/atom:feed/atom:entry');
    foreach my $item_node (@item_nodes) {
        push @items, parse_item($xpath, $item_node);
    }

    return \@items;
}

sub parse_item {
    my ($xpath, $node) = @_;

    my @links = map { $_->textContent } $xpath->findnodes('./atom:link[@rel != "alternate" and @rel != "edit"]/@href', $node);

    return {
        guid        => $xpath->findvalue('./atom:id', $node),
        title       => $xpath->findvalue('./atom:title', $node),
        published   => $xpath->findvalue('./atom:updated', $node),
        summary     => $xpath->findvalue('./atom:summary', $node),
        content     => $xpath->findvalue('./atom:content', $node),
        links       => \@links,
    };
}

1;
