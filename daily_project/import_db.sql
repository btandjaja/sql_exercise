DROP TABLE IF EXISTS project;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  users_id INTEGER NOT NULL,
  FOREIGN KEY (users_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,
  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)

);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  body TEXT,
  parent_id INTEGER,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,
  FOREIGN KEY (questions_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (users_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  like_question BOOLEAN,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,
  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname,lname)
VALUES
  ("Albert", "Boy"),
  ("Jane", "Girl");

INSERT INTO
  questions(title,body,users_id)
VALUES
  ("Chem", "What is Chem?",(SELECT id FROM users WHERE fname = 'Albert')),
  ("Math", "What is Math?",(SELECT id FROM users WHERE fname = 'Jane'));


INSERT INTO
  replies(body, parent_id, users_id, questions_id)
VALUES
  ("Chem is chemistry", NULL, (SELECT id FROM users WHERE fname = 'Albert'),
  (SELECT id FROM questions WHERE title = 'Chem'));

INSERT INTO
  replies(body, parent_id, users_id, questions_id)
VALUES
  ("Chemistry is life", (SELECT id FROM replies WHERE body LIKE 'Chem%'),
   (SELECT id FROM users WHERE fname = 'Albert'),
   (SELECT id FROM questions WHERE title = 'Chem'));
