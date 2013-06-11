package Reader::Parser::Atom;
use warnings;
use strict;

sub parse_header {
    my ($class, $xpath) = @_;

    # get all author names
    my $author_nodeset = $xpath->find('/feed/author/name');
    my @authors = map { $_->string_value } $author_nodeset->get_nodelist;

    # get all header <link> href, except those with rel=self
    my $link_nodeset = $xpath->find('/feed/link[@rel!="self"]/@href');
    my @links = map { $_->string_value } $link_nodeset->get_nodelist;

    return {
        format      => 'atom',
        title       => $xpath->getNodeText('/feed/title')->value,
        description => $xpath->getNodeText('/feed/subtitle')->value,
        updated     => $xpath->getNodeText('/feed/updated')->value,
        links       => \@links,
        authors     => \@authors,
    };
}

sub parse_items {
    my ($class, $xpath) = @_;

    my @items;
    my $item_nodeset = $xpath->find('/feed/entry');
    foreach my $item_context ($item_nodeset->get_nodelist) {
        push @items, parse_item($xpath, $item_context);
    }

    return \@items;
}

sub parse_item {
    my ($xpath, $context) = @_;

    my $link_nodeset = $xpath->find('./link[@rel != "alternate" and @rel != "edit"]/@href', $context);
    my @links = map { $_->string_value } $link_nodeset->get_nodelist;

    return {
        title       => $xpath->find('./title', $context)->string_value,
        published   => $xpath->find('./updated', $context)->string_value,
        summary     => $xpath->find('./summary', $context)->string_value,
        links       => \@links,
    };
}

1;
