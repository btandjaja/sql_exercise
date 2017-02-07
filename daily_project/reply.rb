require 'sqlite3'
require_relative 'users'

class Replies
  attr_accessor :body, :parent_id
  attr_reader :id
  def self.all
    data = Questions.instance.execute('SELECT * FROM replies')
    data.map { |datum| Replies.new(datum)}
  end

  def self.find_by_id
    replies =  Questions.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless replies.length > 0
    Replies.new(replies.first)
  end

  def self.find_by_name
    replies =  Questions.instance.execute(<<-SQL, @fname, @lname)
      SELECT
        *
      FROM
        replies
      WHERE
        fname = ?, lname = ?
    SQL
    replies.map { |reply| Replies.new(reply)  }
  end

  def initialize(option)
    @id = option['id']
    @body = option['body']
    @parent_id = option['parent_id']
    @users_id = option['users_id']
    @questions_id = option['questions_id']
  end

  def create
    raise "#{self} already in database" if @id
    Questions.instance.execute(<<-SQL, @body, @parent_id, @users_id, @questions_id)
      INSERT INTO
        replies (body, parent_id, users_id, questions_id)
      VALUES
        (?, ?, ?, ?)
    SQL
    @id = Questions.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    Questions.instance.execute(<<-SQL, @body, @parent_id, @users_id, @questions_id, @id)
      UPDATE
        replies
      SET
        body = ?, parent_id = ?, users_id = ?, questions_id = ?
      WHERE
        id = ?
    SQL
  end
end
