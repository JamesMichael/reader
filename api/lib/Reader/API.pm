package Reader::API;
use warnings;
use strict;

use Reader::API::Router qw( GET POST );

# return auth token
GET '/token' => sub {
    (200, { }, {
        token => 'abcdef',
        expires => '2013-06-08-17:54',
    })
};

# unread count, either total or for a feed
GET '/stats/count/[:state]/[:feedid]' => sub {
    (200, { }, { unread_count => 123 })
};

# feed list
GET '/feeds' => sub {
    (200, { }, {
        feeds => [
            {
                id          => 1,
                uri         => 'http://example.com/feed.xml',
                title       => 'An Example RSS Feed',
                link        => 'http://example.com/news',
                description => 'Lorem ipsum dolor sit amet',
                author      => 'John Doe',
            },
        ],
    })
};

# a specific feed
GET '/feeds/:id' => sub {
    (200, { }, {
        id          => 1,
        uri         => 'http://example.com/feed.xml',
        title       => 'An Example RSS Feed',
        link        => 'http://example.com/news',
        description => 'Lorem ipsum dolor sit amet',
        author      => 'John Doe',
    })
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
    (200, { }, {
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

# get a specific item
GET '/items/:id' => sub {
    (200, { }, {
        id          => 1,
        feed_id     => 1,
        title       => 'Example Entry',
        link        => 'http://example.com/news/example-entry',
        content     => '<strong>Lorem ipsum dolor sit amet</strong><p>...</p>',
        summary     => 'Lorem ipsum dolor sit amet',
        published   => '2013-06-08 13:09:00',
    })
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
