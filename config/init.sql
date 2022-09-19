DROP DATABASE memo_app;
CREATE DATABASE memo_app;
\c memo_app;
CREATE TABLE memos(
    id int not null,
    title varchar(20) not null,
    content text,
    primary key(id)
);
INSERT INTO memos VALUES
    (1, 'memo1', 'memo1-content'),
    (2, 'memo2', 'memo2-content')
