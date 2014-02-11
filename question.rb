
class Question
  def self.all
    query = <<-SQL
    SELECT
      *
    FROM
    questions
    SQL

    results = QuestionsDatabase.instance.execute(query)
    results.map { |question| Question.new(question) }
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
    SQL


    results = QuestionsDatabase.instance.execute(query, id)
    return Question.new(results.first) unless results.empty?
    nil
  end

  def self.find_by_author_id(id)
    query = <<-SQL
    SELECT
    *
    FROM
    questions
    WHERE
    user_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return results.map { |question| Question.new(question) } unless results.empty?
    nil
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_reader :id, :title, :body, :user_id


  def initialize(options = {})
    @id, @title, @body, @user_id = options.values_at('id', 'title', 'body', 'user_id')
  end

  def author
    User.find_by_id(self.user_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollower.followers_for_question_id(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end

  def create


  end

end
