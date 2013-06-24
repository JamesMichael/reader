CREATE TABLE feed (
    id INTEGER PRIMARY KEY,
    uri TEXT NOT NULL,
    title TEXT NOT NULL,
    link TEXT NOT NULL,
    description TEXT NOT NULL,
    author TEXT NOT NULL,
    priority TEXT DEFAULT 'normal',
    paused INTEGER NOT NULL DEFAULT 0
);
