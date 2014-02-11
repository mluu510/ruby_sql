class QuestionLike
  def self.all
    query = <<-SQL
    SELECT
      *
    FROM
      question_likes
    SQL

    results = QuestionsDatabase.instance.execute(query)
    results.map { |like| QuestionLike.new(like) }
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      question_likes
    WHERE
      id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return QuestionLike.new(results.first) unless results.empty?
    nil
  end


  def self.likers_for_question_id(question_id)
    #returns array of users that like a question
    query = <<-SQL
    SELECT
    *
    FROM
      question_likes
    JOIN
      users
    ON
      question_likes.user_id = users.id
    WHERE
      question_likes.question_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, question_id)
    return results.map { |user| User.find_by_id(user['user_id']) } unless results.empty?
    nil
  end

  def self.num_likes_for_question_id(question_id)
    query = <<-SQL
    SELECT
      COUNT(*) AS count
    FROM
      question_likes
    WHERE
      question_id = ?
    SQL

    result = QuestionsDatabase.instance.execute(query, question_id)
    result.first['count']
  end

  def self.liked_questions_for_user_id(user_id)
    query = <<-SQL
    SELECT
      *
    FROM
      question_likes
    JOIN
      questions
    ON
      question_likes.question_id = questions.id
    WHERE
      question_likes.user_id = ?

    SQL

    results = QuestionsDatabase.instance.execute(query, user_id)
    return results.map { |question| Question.find_by_id(question['question_id']) } unless results.empty?
    nil
  end

  def self.most_liked_questions(n)
    query = <<-SQL
    SELECT
    question_id, COUNT(user_id) AS count
    FROM
    question_likes
    GROUP BY question_id
    ORDER BY COUNT(user_id) DESC limit ?
    SQL

    results = QuestionsDatabase.instance.execute(query, n)
    return results.map { |question| Question.find_by_id(question['question_id']) } unless results.empty?
    nil
  end

  attr_reader :id, :question_id, :user_id


  def initialize(options = {})
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end

  def create


  end

end