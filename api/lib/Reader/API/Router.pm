package Reader::API::Router;
use warnings;
use strict;

use URI;
use Exporter qw(import);
our @EXPORT = qw( GET POST DELETE route );

use Reader::API::Format;
use Reader::API::Handler;

our %ROUTES;

# this contains logic for routing requests
# on success, (0, handler) is returned
# on failure, (error_code, error_message) is returned
sub route {
    my $request = shift;

    my $uri = $request->{request}->uri;
    my $full_path = $uri->path;

    # move to another routine
    my ($path, $format_name) = ($full_path, 'json');
    if ($full_path =~ /(.*)\.([^\.]+)$/) {
        ($path, $format_name) = ($1, $2);
    }

    my $method = $request->{request}->method;
    unless ($ROUTES{$method}) {
        # 400 bad request
        # perhaps 405 would be more suitable,
        # this would require checking all methods for matches however
        return (400, "invalid method: $method");
    }

    my $matching_route;
    foreach my $route (@{ $ROUTES{$method} }) {
        next unless $path =~ $route->regex;
        return (0, $route);
        last;
    }

    unless ($matching_route) {
        # again, 405 might be more suitable response,
        # provided this request is served by a different method
        return (404, "no matching route");
    }

    return (500, "route bottommed out");
}

sub GET($$) {
    _define_route('GET', @_);
}

sub POST($$) {
    _define_route('POST', @_);
}

sub DELETE($$) {
    _define_route('DELETE', @_);
}

sub _define_route {
    my ($method, $route, $coderef) = @_;

    # check method is valid
    # check route is valid/defined
    # check coderef is valid/defined

    my ($regex, $parameter_names);
    if (ref $route eq 'Regexp') {
        $regex = $route;
    } else {
        ($regex, $parameter_names) = _convert_route_to_regex($route);
    }

    push @{ $ROUTES{$method} }, Reader::API::Handler->new(
        route       => $route,
        regex       => $regex,
        parameters  => $parameter_names,
        action      => $coderef,
    );
}

sub _convert_route_to_regex {
    my $route = shift;
    my $original_route = $route;

    my @parameter_names;
    my $regex = '^';
    while (length $route) {

        my ($chunk, $separator, $remainder);
        if ($route =~ /(.*?)(\:|\/\[)(.*)/) {
            ($chunk, $separator, $remainder) = ($1, $2, $3);
            $regex .= $chunk;
        } else {
            $regex .= $route;
            last;
        }

        # extract parameter name
        if ($separator eq ':') {
            my ($parameter_name, $remainder) = $remainder =~ /([^\/]+)(.*)/;
            push @parameter_names, $parameter_name;
            $route = $remainder;
            $regex .= '([^/]+)';
            next;
        }

        # optional segment
        if ($separator eq '/[') {
            my ($parameter_name, $remainder) = $remainder =~ /:([^\]]+)\](.*)/;
            push @parameter_names, $parameter_name;

            $route = $remainder;

            $regex .= '(?:/([^/]+))?';
            next;
        }

        warn "Regex wasn't handled properly: $original_route\n";
        last;

    }

    # trailing slashes are optional
    $regex .= '/?$';

    return (qr{$regex}, \@parameter_names);
}

1;
