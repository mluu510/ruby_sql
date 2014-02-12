CREATE TABLE tags (
	id INTEGER PRIMARY KEY,
	tag TEXT NOT NULL
)

CREATE TABLE question_tags (
	id INTEGER PRIMARY KEY,
	tag_id INTEGER,
	question_id INTEGER,

	FOREIGN KEY (tag_id) REFERENCES tags(id)
	FOREIGN KEY (question_id) REFERENCES questions(id)
)