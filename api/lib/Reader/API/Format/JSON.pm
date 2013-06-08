package Reader::API::Format::JSON;
use Moose;
use JSON;

use Reader::API::Format;
extends 'Reader::API::Format';

sub format_response {
    my ($self, $content) = @_;

    if (ref $content) {
        return encode_json($content);
    }

    return encode_json({ message => $content });
}

sub mime_type {
    return 'application/json';
}

no Moose;
__PACKAGE__->meta->make_immutable;
