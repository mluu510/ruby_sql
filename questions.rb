require 'singleton'
require 'sqlite3'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('aa_questions.db')

    self.results_as_hash = true

    self.type_translation = true
  end
end


class User
  def self.all
    query = <<-SQL
    SELECT
      *
    FROM
      users
    SQL

    results = QuestionsDatabase.instance.execute(query)
    results.map { |user| User.new(user) }
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return User.new(results.first) unless results.empty?
    nil
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, fname, lname)
    return  results.map { |user| User.new(user) } unless results.empty?
    nil
  end

  attr_reader :id, :fname, :lname


  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    results = Question.find_by_author_id(self.id)
  end

  def authored_replies
    query = <<-SQL
    SELECT
    *
    FROM
    replies
    WHERE
    user_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, self.id)
    return  results.map { |reply| Reply.new(reply) } unless results.empty?
    nil
  end



  def create


  end

end





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

  def create


  end

end

class QuestionFollower
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


  attr_reader :id, :question_id, :user_id


  def initialize(options = {})
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end

  def create


  end

end

class Reply
  def self.all
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    SQL

    results = QuestionsDatabase.instance.execute(query)
    results.map { |reply| Reply.new(reply) }
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return Reply.new(results.first) unless results.empty?
    nil
  end

  def self.children(id)
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE
      reply_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return Reply.new(results.first) unless results.empty?
    nil
  end


  def self.find_by_question_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL

    results = QuestionsDatabase.instance.execute(query, id)
    return results.map{ |reply| Reply.new(reply) } unless results.empty?
    nil
  end

  attr_reader :id, :question_id, :reply_id, :user_id, :body


  def initialize(options = {})
    @id, @question_id, @reply_id, @user_id, @body = options.values_at('id',
                                                                      'question_id',
                                                                      'reply_id',
                                                                      'user_id',
                                                                      'body')
  end

  def create


  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.reply_id)
  end

  def child_replies
    Reply.children(self.id)
  end

end

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


  attr_reader :id, :question_id, :user_id


  def initialize(options = {})
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end

  def create


  end

end