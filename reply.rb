
class Reply < SQLObject
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

  attr_accessor :question_id, :reply_id, :user_id, :body
  attr_reader :id


  def initialize(options = {})
    @id, @question_id, @reply_id, @user_id, @body = options.values_at('id',
                                                                      'question_id',
                                                                      'reply_id',
                                                                      'user_id',
                                                                      'body')
  end

  def sql_columns
    [:question_id, :reply_id, :user_id, :body]
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

  def self.pluralize
    'replies'
  end

end
