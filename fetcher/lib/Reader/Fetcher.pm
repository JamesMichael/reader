package Reader::Fetcher;
use warnings;
use strict;
use lib "/opt/reader/lib";

use Reader::Model;
use LWP::UserAgent;
use HTTP::Request::Common qw(GET);

use Readonly;
Readonly my $OUTPUT_DIR => "/opt/reader/var/feeds/unparsed";

sub fetch {
    my $feed = shift;

    my $feed_id = $feed->id;
    my $uri     = $feed->uri;
    my $title   = $feed->title;

    my $filename = "$OUTPUT_DIR/$feed_id.xml";
    print "downloading '$title' ($uri) to $filename\n";

    my $ua = LWP::UserAgent->new;
    $ua->agent('Mozilla/8.0');

    my $request = GET $uri;
    my $result = $ua->request($request, $filename);

    if ($result->is_success) {
        print "Successfully downloaded\n";
        return 1;
    } else {
        print "Failed: " . $result->status_line, "\n";
        return 0;
    }
};

1;
