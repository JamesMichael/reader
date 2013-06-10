package Reader::API::Handler;
use Moose;

has route       => ( is => 'ro', isa => 'Str'           );
has regex       => ( is => 'ro', isa => 'RegexpRef'     );
has parameters  => ( is => 'ro', isa => 'ArrayRef[Str]' );
has action      => ( is => 'ro', isa => 'CodeRef'       );

sub run {
    my ($self, $request) = @_;

    # extract named parameters from the path
    my @parameters = ($request->{request}->uri->path =~ $self->regex);
    my @parameter_names = @{$self->parameters};
    my %parameters;
    foreach my $i (0..$#parameter_names) {
        $parameters{$parameter_names[$i]} = $parameters[$i];
    }

    $self->{action}->(\%parameters, @_);
};

sub as_string {
    my $self = shift;
    return $self->route;
}

no Moose;
__PACKAGE__->meta->make_immutable;
