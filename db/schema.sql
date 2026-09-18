CREATE DATABASE memo_app;

\c memo_app

CREATE TABLE memos (
    id      integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title   text NOT NULL,
    content text NOT NULL
);
