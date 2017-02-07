require 'sqlite3'
require 'singleton'

class Questions< SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Users
  attr_accessor :fname, :lname
  attr_reader :id
  def self.all
    data = Questions.instance.execute('SELECT * FROM users')
    data.map { |datum| Users.new(datum)}
  end

  def self.find_by_id
    users =  Questions.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless users.length > 0
    Users.new(users.first)
  end

  def self.find_by_name
    users =  Questions.instance.execute(<<-SQL, @fname, @lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?, lname = ?
    SQL
    users.map { |user| Users.new(user)  }
  end

  def initialize(option)
    @id = option['id']
    @fname = option['fname']
    @lname = option['lname']
  end

  def create
    raise "#{self} already in database" if @id
    Questions.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname,lname)
      VALUES
        (?, ?)
    SQL
    @id = Questions.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless @id
    Questions.instance.execute(<<-SQL,  @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end
end
