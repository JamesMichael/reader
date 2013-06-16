package Reader::Parser;
use warnings;
use strict;

use Carp;
use XML::XPath;
use Reader::Parser::Atom;
use Reader::Parser::RSS;

sub parse {
    my $filename = shift;
    my $xpath = XML::XPath->new( filename => $filename );

    my $document_type = detect_document_type($xpath);
    return 0 if $document_type eq 'unknown';

    my $parser = $document_type eq 'rss'    ? 'Reader::Parser::RSS'
               : 'Reader::Parser::Atom';

    my $header = $parser->parse_header($xpath);
    my $items  = $parser->parse_items($xpath);

    return (1, $header, $items);
}

sub detect_document_type {
    my $xpath = shift;

    return 'rss'    if $xpath->exists('/rss');
    return 'atom'   if $xpath->exists('/feed');
    return 'unknown';
}

1;
