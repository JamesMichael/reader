package Reader::Parser;
use warnings;
use strict;

use Carp;
use XML::LibXML;
use XML::LibXML::XPathContext;
use File::Slurp;
use Reader::Parser::Atom;
use Reader::Parser::RSS;

sub parse {
    my $filename = shift;

    my $xml = read_file($filename);
    $xml =~ s/&\s/&amp; /g;

    my $parser = XML::LibXML->load_xml(
        string      => $xml,
        recover     => 2,
        keep_blanks => 0,       # returns cdata
    );

    my $xpath = XML::LibXML::XPathContext->new($parser);
    $xpath->registerNs('atom', 'http://www.w3.org/2005/Atom');

    my $document_type = detect_document_type($xpath);
    return 0 if $document_type eq 'unknown';

    my $parser_package = $document_type eq 'rss'    ? 'Reader::Parser::RSS'
                       : 'Reader::Parser::Atom';

    my $header = $parser_package->parse_header($xpath);
    my $items  = $parser_package->parse_items($xpath);

    return (1, $header, $items);
}

sub detect_document_type {
    my $xpath = shift;

    return 'rss'    if $xpath->exists('/rss');
    return 'atom'   if $xpath->exists('/atom:feed');
    return 'unknown';
}

1;
