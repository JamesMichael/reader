CREATE TABLE state (
    id INTEGER PRIMARY KEY,
    state TEXT NOT NULL
);

INSERT INTO state (state) VALUES ('unread');
INSERT INTO state (state) VALUES ('read');
INSERT INTO state (state) VALUES ('starred');
INSERT INTO state (state) VALUES ('error');
