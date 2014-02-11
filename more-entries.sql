INSERT INTO
	questions(title, body, user_id)
VALUES
   ('how is the coffe there?', 'I need to know what the coffee situation is....',
   (SELECT id FROM users WHERE fname = 'minh' AND lname = 'luu'));

 INSERT INTO
 	questions(title, body, user_id)
 VALUES
    ("Where is the nearest laundrymat?", "I'm running out of clean clothes!",
    (SELECT id FROM users WHERE fname = 'minh' AND lname = 'luu'));


		INSERT INTO
	question_likes(question_id, user_id)
	VALUES
(3, 1);



SELECT
question_id, COUNT(*) as likes
FROM
question_likes
JOIN
users
	ON
	question_likes.user_id = users.id
		Join
		questions
		ON
		question_likes.question_id = questions.id
		WHERE
	questions.user_id = ?
GROUP BY question_id




SELECT
question_id, COUNT(*) as likes
FROM
question
LEFT OUTER JOIN
question_likes
	ON
	question.user_id = question_likes.user_id
		WHERE
	questions.user_id = ?
GROUP BY question_id