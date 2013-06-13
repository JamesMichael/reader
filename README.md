# RSS Reader

## Setting up

### Database

1. Initialise database structures

        cd model
        sqlite3 reader.db < db/*

## Testing API

1. Get Feeds

        curl -i localhost:11122/feeds

2. Add Feed

        curl -i localhost:11122/feeds/new --data-urlencode 'uri=http://example.com/rss.xml'

## API

### Dependencies

#### CPAN Modules

* [JSON](https://metacpan.org/module/MAKAMAKA/JSON-2.59/lib/JSON.pm)
* [URI](https://metacpan.org/module/GAAS/URI-1.60/URI.pm)
* [Moose](https://metacpan.org/module/ETHER/Moose-2.0802/lib/Moose.pm)
* [Readonly](https://metacpan.org/module/ROODE/Readonly-1.03/Readonly.pm)
* [DBIx::Class](https://metacpan.org/module/DBIx::Class)
* [HTTP::Message](https://metacpan.org/module/GAAS/HTTP-Message-6.06/lib/HTTP/Message.pm)

### Running

    cd api
    bin/api_server
