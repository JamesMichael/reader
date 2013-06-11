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

1;
