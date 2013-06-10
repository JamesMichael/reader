CREATE TABLE item (
    id INTEGER PRIMARY KEY,
    feed_id INTEGER NOT NULL REFERENCES feed(id),
    state_id INTEGER REFERENCES state(id),
    title TEXT NOT NULL,
    link TEXT NOT NULL,
    content TEXT NOT NULL,
    published TEXT INTEGER
);
