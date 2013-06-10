package Reader::API;
use warnings;
use strict;

use Reader::API::Router qw( GET POST );
use FindBin;
use lib "$FindBin::Bin/../../model/lib";

use Reader::Model;

# return auth token
GET '/token' => sub {
    (200, { }, {
        token => 'abcdef',
        expires => '2013-06-08-17:54',
    })
};

# unread count, either total or for a feed
GET '/stats/count/[:state]/[:feedid]' => sub {
    my ($parameters, $request) = @_;

    my $model = Reader::Model::model();
    my $resultset = $model->resultset('Item')->search(
        {
            $parameters->{state}    ? ('state.state' => $parameters->{state})   : (),
            $parameters->{feedid}   ? ('me.feed_id'   => $parameters->{feedid})  : (),
        },
        {
            join => 'state',
        },
    );

    (200, { }, { count => $resultset->count });
};

# feed list
GET '/feeds' => sub {
    my ($parameters, $request) = @_;

    my $model = Reader::Model::model();
    my $resultset = $model->resultset('Feed')->search(
        {
        },
        {
        },
    );

    my @feeds;
    while (my $feed = $resultset->next) {
        push @feeds, $feed->feed;
    }

    (200, { }, { feeds => \@feeds });
};

# a specific feed
GET '/feeds/:id' => sub {
    my ($parameters, $request) = @_;

    my $model = Reader::Model::model();
    my $resultset = $model->resultset('Feed')->search(
        {
            'me.id' => $parameters->{id},
        },
        {
        },
    );

    my $feed = $resultset->first;

    return (200, { }, $feed->feed) if $feed;
    return (404, { }, 'invalid feed id');
};

# add tags, change name
# post query specifies actions to be performed
POST '/feeds/:id' => sub {
    (200, { }, {
        message     => 'success',
    })
};


# all items (optionally filtered by state)
GET '/list/[:state]' => sub {
    my ($parameters, $request) = @_;

    my $model = Reader::Model::model();
    my $resultset = $model->resultset('Item')->search(
        {
            $parameters->{state} ? ('state.state' => $parameters->{state}) : (),
        },
        {
            join => 'state',
        },
    );

    my @items;
    while (my $item = $resultset->next) {
        push @items, $item->item;
    }

    (200, { }, { items => \@items });
};

# get a specific item
GET '/items/:id' => sub {
    my ($parameters, $request) = @_;

    my $model = Reader::Model::model();
    my $resultset = $model->resultset('Item')->search(
        {
            'me.id' => $parameters->{id},
        },
        {
            join => 'state',
        },
    );

    my $item = $resultset->first;

    return (200, { }, $item->item) if $item;
    return (404, { }, 'invalid item id');
};

# update an item, POST data contains actions
POST '/items/:id' => sub {
    (200, { }, {
        message     => 'success',
    })
};

# search through items
GET '/search' => sub {
    (200, { }, {
        results => 1,
        items => [
            {
                id          => 1,
                feed_id     => 1,
                title       => 'Example Entry',
                link        => 'http://example.com/news/example-entry',
                content     => '<strong>Lorem ipsum dolor sit amet</strong><p>...</p>',
                summary     => 'Lorem ipsum dolor sit amet',
                published   => '2013-06-08 13:09:00',
            },
        ],
    })
};

1;
