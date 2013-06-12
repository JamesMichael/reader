package Reader::Fetcher;
use warnings;
use strict;

use FindBin;
use lib "$FindBin::Bin/../../model/lib";

use Reader::Model;
use LWP::UserAgent;
use HTTP::Request::Common qw(GET);

use Readonly;
Readonly my $OUTPUT_DIR => "$FindBin::Bin/../var/reader/feeds/unparsed";

sub fetch {
    my ($feed_id) = @_;

    my $model = Reader::Model::model();
    my $feed = $model->resultset('Feed')->find($feed_id);

    unless ($feed) {
        die 'Invalid item id';
    }

    my $uri = $feed->uri;
    my $title = $feed->title;

    my $filename = "$OUTPUT_DIR/$feed_id.xml";
    print "downloading '$title' ($uri) to $filename\n";

    my $ua = LWP::UserAgent->new;
    $ua->agent('Mozilla/8.0');

    my $request = GET $uri;
    my $result = $ua->request($request, $filename);

    if ($result->is_success) {
        print "Successfully downloaded\n";
    } else {
        print "Failed: " . $result->status_line, "\n";
    }
};

1;
