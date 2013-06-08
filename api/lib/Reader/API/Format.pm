package Reader::API::Format;

use Moose;
use Readonly;
Readonly my %FORMATS => (
    'json'  => 'Reader::API::Format::JSON',
);

has format => ( is => 'ro', 'isa' => 'Str' );

sub format_response {
    return '';
}

sub mime_type {
    return 'text/plain';
}

# class method
sub has_format {
    my $format_name = shift || '';
    return $FORMATS{$format_name};
}

# factory method
sub formatter {
    my ($format, @parameters) = @_;
    return unless $FORMATS{$format};

    my $package = $FORMATS{$format};
    eval "require $package";

    if ($@) {
        print "Could not load $package: $@\n";
        return;
    }

    return $package->new(@parameters);
}

no Moose;
__PACKAGE__->meta->make_immutable;
