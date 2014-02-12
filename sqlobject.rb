class SQLObject

  def initialize
    raise "You can't initialize this shit.  This is only an abstract, sup-par version of ActiveRecord::BASE"
  end

  def save
    options = {}
    self.sql_columns.each do |column|
      options[column] = self.send(column)
    end
    if self.id.nil?
      # Create a new row
      query = <<-SQL
      INSERT INTO #{self.pluralize}(#{self.sql_columns.map { |column| column.to_s }.join(', ')})
      VALUES (#{self.sql_columns.map { |column| ":#{column.to_s}" }.join(', ')})
      SQL

      QuestionsDatabase.instance.execute(query, options)
      @id = QuestionsDatabase.instance.last_insert_row_id

    else
      # Updating row
      options[:id] = self.id
      query = <<-SQL
      UPDATE #{self.pluralize}
      SET #{self.sql_columns.map { |column| "#{column.to_s} = :#{column.to_s}" }.join(', ')}
      WHERE id = :id
      SQL

      QuestionsDatabase.instance.execute(query, options)
    end

  end

  def pluralize
    self.class.to_s.downcase + 's'
  end
end