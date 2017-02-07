require 'sqlite3'
require_relative 'users'

class Question
  attr_accessor :body, :parent_id
  attr_reader :id
  def self.all
    data = Questions.instance.execute('SELECT * FROM questions')
    data.map { |datum| Question.new(datum)}
  end

  def self.find_by_id
    questions =  questions.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless questions.length > 0
    Question.new(questions.first)
  end

  def self.find_by_name
    questions =  questions.instance.execute(<<-SQL, @title, @body, @users_id)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?, body = ?, users_id = ?
    SQL
    questions.map { |question| Question.new(question)  }
  end

  def initialize(option)
    @id = option['id']
    @title = option['title']
    @body = option['body']
    @users_id = option['users_id']
  end

  def create
    raise "#{self} already in database" if @id
    Question.instance.execute(<<-SQL, @title, @body, @users_id)
      INSERT INTO
        questions (title, body, users_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = Questions.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    Questions.instance.execute(<<-SQL, @title, @body, @users_id, @id)
      UPDATE
        questions
      SET
        title = ?, body = ?, uses_id = ?
      WHERE
        id = ?
    SQL
  end
end
