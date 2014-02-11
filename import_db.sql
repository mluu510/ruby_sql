CREATE TABLE users (
	id INTEGER PRIMARY KEY,
	fname TEXT NOT NULL,
	lname TEXT NOT NULL
);

CREATE TABLE questions (
	id INTEGER PRIMARY KEY,
	title TEXT NOT NULL,
	body TEXT NOT NULL,
	user_id INTEGER NOT NULL,

	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,

	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	reply_id INTEGER,
	user_id INTEGER NOT NULL,
	body TEXT NOT NULL,

	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,

	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (user_id) REFERENCES user(id)
);


INSERT INTO
	users (fname, lname)
VALUES
	('kevin', 'ford'),
('minh', 'luu');

INSERT INTO
	questions(title, body, user_id)
VALUES
   ('where are you located?', 'I was wondering what the address of app academy is',
   (SELECT id FROM users WHERE fname = 'kevin' AND lname = 'ford'));
