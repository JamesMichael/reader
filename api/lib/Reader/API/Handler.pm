package Reader::API::Handler;
use Moose;

has route       => ( is => 'ro', isa => 'Str'           );
has regex       => ( is => 'ro', isa => 'RegexpRef'     );
has parameters  => ( is => 'ro', isa => 'ArrayRef[Str]' );
has action      => ( is => 'ro', isa => 'CodeRef'       );

sub run {
    my $self = shift;

    # TODO: set parameters

    $self->{action}->(@_);
};

sub as_string {
    my $self = shift;
    return $self->route;
}

no Moose;
__PACKAGE__->meta->make_immutable;
