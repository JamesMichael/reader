package Reader::Fetcher;
use warnings;
use strict;
use lib "/opt/reader/lib";

use Reader::Model;
use LWP::UserAgent;
use HTTP::Request::Common qw(GET);

use Readonly;
Readonly my $OUTPUT_DIR => "/opt/reader/var/feeds/unparsed";

$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

sub fetch {
    my ($feed, $fetch_tag) = @_;

    my $feed_id = $feed->id;
    my $uri     = $feed->uri;
    my $title   = $feed->title;

    my $filename = "$OUTPUT_DIR/$feed_id.$fetch_tag.xml";
    print "downloading '$title' ($uri) to $filename\n";

    my $ua = LWP::UserAgent->new;
    $ua->agent('Mozilla/8.0');

    my $result = $ua->get($uri,
        'Accept-Encoding' => HTTP::Message::decodable,
    );

    if ($result->is_success) {
        open my $outfh, '>', $filename or croak $!;
        print $outfh $result->decoded_content(charset => 'none');
        close $outfh;
    }

    return ($result->is_success, $result->status_line);
};

1;
