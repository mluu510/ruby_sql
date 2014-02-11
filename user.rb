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

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end


  def create


  end

end