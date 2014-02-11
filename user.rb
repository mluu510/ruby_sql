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

  attr_reader :id
  attr_accessor :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def save
    if self.id.nil?
      # puts "Creating a new row"
      # Create a new row
      query = <<-SQL
    INSERT INTO users(fname, lname)
  VALUES (:fname, :lname)
      SQL

      QuestionsDatabase.instance.execute(query, {:fname => self.fname, :lname => self.lname})
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      # puts "Updating row: #{self.id}"
      # Update row
      query = <<-SQL
      UPDATE users
      SET fname = :fname, lname = :lname
  WHERE id = :id
      SQL

      QuestionsDatabase.instance.execute(query, {:fname => self.fname, :lname => self.lname, :id => self.id})
    end
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

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    query = <<-SQL
    SELECT
    CAST(COUNT(*) as FLOAT) / (
    	SELECT COUNT(*)
    	FROM questions
    	WHERE questions.user_id = ?
    ) as average_likes

    FROM
    question_likes
    JOIN
    questions
    	ON
    	question_likes.question_id = questions.id
    		WHERE
    	questions.user_id = ?
    SQL

     results = QuestionsDatabase.instance.execute(query, self.id, self.id)
     results.first.values.first
  end

  def create


  end

end