package Reader::API::Server;
use Moose;
use Carp;
use threads;

use IO::Socket;
use URI::Escape;
use HTTP::Request;
use HTTP::Response;

use Reader::API::Router qw( route );

has port => ( is => 'ro', isa => 'Int' );

sub run {
    my $self = shift;
    my $port = $self->port;

    print "starting server on port $port...";

    # open socket to listen locally
    my $server = IO::Socket::INET->new(
        LocalHost   => 'localhost',
        LocalPort   => $self->port,
        Listen      => 20,
        Proto       => 'tcp',
        Reuse       => 1,
    ) or croak "Could not create socket: $@";

    print "server started\n";

    # for each connection, spawn a new thread
    while (my $socket = $server->accept) {
        async { $self->_handle_request($socket) };
    }

    # should this ever happen?
    print "stopping server\n";
}

sub _handle_request {
    my ($self, $socket) = @_;

    threads->detach;
    $SIG{KILL} = sub { threads->exit };

    # read and parse http request
    my $request = _read_http_request($socket);

    # choose the output format based on the file extension
    my $path = $request->{request}->uri->path;
    my $format_name = $path =~ /\.[^\.]+$/;
    my $format;
    if (Reader::API::Format::has_format($format_name)) {
        $format = Reader::API::Format::formatter($format_name);
    } else {
        $format = Reader::API::Format::formatter('json');
    }

    # find the handler for the requested path
    my ($code, $handler) = route($request);

    my ($status_code, $headers, $content);
    if (ref $handler) {
        ($status_code, $headers, $content) = $handler->run($request);
    } else {
        # ideally, print detailed message to the error log,
        # return generic 'error' for clients
        ($status_code, $headers, $content) = (404, {}, "ERROR: $handler");
    }

    # format response
    my $response = HTTP::Response->new($status_code);
    $response->protocol('HTTP/1.1');

    while (my ($header, $value) = each %$headers) {
        $response->header($header => $value);
    }

    $response->header('Content-Type' => $format->mime_type);
    $response->content($format->format_response($content));

    # output response
    print $socket $response->as_string;
}

# reads the http from the socket into a HTTP::Request
# also turns the parameters into hashrefs
# and gets the client details from the socket
#
# TODO: look into detecting closed sockets
sub _read_http_request {
    my $socket = shift;
    my ($peer_host, $peer_port) = ($socket->peerhost, $socket->peerport);
    print "Accepted connection from $peer_host:$peer_port\n";

    my $request_line = <$socket>;
    my $request = HTTP::Request->parse($request_line);

    while (my $header = <$socket>) {
        last if $header =~ /^\s*$/;

        # header regex borrowed from HTTP::Server::Simple
        if ($header =~ /^([^()<>\@,;:\\"\/\[\]?={} \t]+):\s*(.*)/i) {
            $request->header($1 => $2);
            next;
        }

        warn q{perhaps this shouldn't happen: invalid header in http request};
        last;
    }

    my $post_query;
    if ($request->method eq 'POST') {
        read $socket, $post_query, $request->content_length;
    }

    my $query_parameters;
    $query_parameters = _parse_query_parameters($request->uri->query);

    my $post_parameters;
    if ($request->method eq 'POST') {
        $post_parameters = _parse_query_parameters($post_query);
    }

    return {
        peer_host       => $peer_host,
        peer_port       => $peer_port,
        query_params    => $query_parameters,
        post_params     => $post_parameters,
        request         => $request,
    };
}

# convert a query string to hashref
sub _parse_query_parameters {
    my $query_string = shift || '';

    my @fields = split /&/, $query_string;
    my %data = map {
        my ($field, $value) = split /=/, $_, 2;
        uri_unescape($field) => uri_unescape($value)
    } @fields;

    return \%data;
}

no Moose;
__PACKAGE__->meta->make_immutable;
