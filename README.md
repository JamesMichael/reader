# RSS Reader

## Database

* The database used by reader is a sqlite database

* This database is located at `/opt/reader/db/reader.db`.

* The schema files are `/opt/reader/db/*.sql`

* Database interaction is performed using the `DBIx::Class` obects found in the `reader-model` package

### Setting up

1. install `reader-tools` package

2. install `reader-model` package

3. run setup database script, with optional subscriptions file

        /opt/reader/bin/setup_database /path/to/subscriptions.xml

## API

### Dependencies

#### CPAN Modules

* [JSON](https://metacpan.org/module/MAKAMAKA/JSON-2.59/lib/JSON.pm)
* [URI](https://metacpan.org/module/GAAS/URI-1.60/URI.pm)
* [Moose](https://metacpan.org/module/ETHER/Moose-2.0802/lib/Moose.pm)
* [Readonly](https://metacpan.org/module/ROODE/Readonly-1.03/Readonly.pm)
* [DBIx::Class](https://metacpan.org/module/DBIx::Class)
* [HTTP::Message](https://metacpan.org/module/GAAS/HTTP-Message-6.06/lib/HTTP/Message.pm)

#### Packages

* reader-model

### Building

    ( cd api && /opt/reader/bin/build )

The built reader-api package can then be found in `~/rpmbuild/RPMS/noarch/`.

### Starting the service

    sudo -i service apid start

### Stopping the service

    sudo -i service apid stop

### Running the server manually

    /opt/reader/bin/api_server [--port <PORT>]

### Testing

The api responds to HTTP requests, and can be tested using curl

#### Examples

1. Get Feeds

        curl -i localhost:11122/feeds

2. Add Feed

        curl -i localhost:11122/feeds/new --data-urlencode 'uri=http://example.com/rss.xml'
