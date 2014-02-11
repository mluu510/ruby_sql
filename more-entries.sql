INSERT INTO
	questions(title, body, user_id)
VALUES
   ('When is lunch?', 'I am starving!!!!',
   (SELECT id FROM users WHERE fname = 'minh' AND lname = 'luu'));



INSERT INTO
	question_followers(question_id, user_id)
VALUES
	((1, 2), (2, 1));