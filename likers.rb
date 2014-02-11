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