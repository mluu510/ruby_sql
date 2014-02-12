

class QuestionFollower < SQLObject
  def self.all
    query = <<-SQL
    SELECT
      *
    FROM
    question_followers
    SQL

    results = QuestionsDatabase.instance.execute(query)
    results.map { |follower| QuestionFollower.new(follower) }
  end

  def self.followers_for_question_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      question_followers
      JOIN users ON
      question_followers.user_id = users.id
    WHERE
      question_followers.question_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return results.map{ |follower| User.new(follower) } unless results.empty?
    nil
  end

  def self.followed_questions_for_user_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      question_followers
      JOIN questions ON
      question_followers.question_id = questions.id
    WHERE
      question_followers.user_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return results.map{ |question| Question.new(question) } unless results.empty?
    nil
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      question_followers
    WHERE
      id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return QuestionFollower.new(results.first) unless results.empty?
    nil
  end

  def self.most_followed_questions(n)
    query = <<-SQL
    SELECT
      question_id, COUNT(user_id)
    FROM
      question_followers
    GROUP BY question_id
    ORDER BY COUNT(user_id) DESC limit ?
    SQL

    results = QuestionsDatabase.instance.execute(query, n)

    # Return an array of Question objects
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