# RSS Reader

## Setting up

### Database

1. Initialise database structures

    cd model
    sqlite3 reader.db < db/*

### Running API Server

1. Launch server

    cd api
    bin/api_server

## Testing API

1. Get Feeds

    curl -i localhost:11122/feeds

2. Add Feed

    curl -i localhost:11122/feeds/new --data-urlencode 'uri=http://example.com/rss.xml'
