CREATE TABLE fetch (
    id INTEGER PRIMARY KEY,
    feed_id INTEGER NOT NULL REFERENCES feed(id),
    fetch_date INTEGER NOT NULL,
    filename TEXT,
    status TEXT NOT NULL
);

