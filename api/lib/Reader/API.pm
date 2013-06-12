package Reader::API;
use warnings;
use strict;

use Reader::API::Router qw( GET POST DELETE );
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

DELETE '/feeds/:id' => sub {
    my ($parameters, $request) = @_;

    my $model = Reader::Model::model();
    my $feed = $model->resultset('Feed')->find($parameters->{id});

    return (404, { }, { message => 'invalid feed id' }) unless $feed;

    $feed->delete;
    return (200, { }, { message => 'success' });
};

# add tags, change name
# post query specifies actions to be performed
POST '/feeds/edit/:id' => sub {
    (200, { }, {
        message     => 'success',
    })
};

POST '/feeds/new' => sub {
    my ($parameters, $request) = @_;

    my $uri = $request->{post_params}{uri};
    return (400, { }, 'uri not specified') unless $uri;

    my $model = Reader::Model::model();

    # check the feed doesn't already exist
    my $count = $model->resultset('Feed')->count({
        'me.uri' => $uri,
    });
    if ($count) {
        return (400, { }, 'uri already exists');
    }

    # add feed to database
    # the fields will be updated once the feed is fetched
    my $feed = $model->resultset('Feed')->create({
        uri         => $uri,
        title       => '',
        link        => '',
        description => '',
        author      => '',
    });

    (200, { }, $feed->feed)
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
    my ($parameters, $request) = @_;

    my $model = Reader::Model::model();
    my $item = $model->resultset('Item')->find($parameters->{id});
    return (404, { }, 'invalid item id') unless $item;

    my $actions = $request->{post_params};
    foreach my $action (keys %$actions) {
        if ($action eq 'mark-read') {
            my $value = $actions->{$action} ? 'read' : 'unread';
            my $state = $model->resultset('State')->search({
                    'me.state' => $value,
            })->single;
            $item->state($state);
            next;
        }
    }

    $item->update;

    (200, { }, {message => 'success'})
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
