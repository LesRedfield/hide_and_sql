require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    unless @columns
      cols = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          '#{table_name}'
      SQL
    end
    # debugger

    @columns ||= cols.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |col|
      define_method(col) do
        attributes[col]
        # self.name
      end

      define_method("#{col}=") do |val|
        # debugger
        attributes[col] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
    # debugger
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    rows = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      SQL
      # debugger

      # better = rows.each { |row| row.each do |col, val| { col = col.to_sym } }

    self.parse_all(rows)

  end

  def self.parse_all(results)


    results.map { |row| self.new(Hash[row.map{|k,v|[k.to_sym, v]}]) }
  end

  def self.find(id)
    rows = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        id = ?
      SQL

    self.parse_all(rows).first
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name)

      self.send("#{attr_name}=", val)
    end
  end

  def attributes
    @attributes ||= {}
    # debugger
    # # syms = self.class.columns
    # # vars = syms.map { |col| col = "@#{col}" }
    # #
    # # # debugger
    # # (0...syms.length).each { |idx| @attributes[syms[idx]] = vars[idx] }
    # @attributes
  end

  def attribute_values
    self.class.columns.map { |col| self.send(col) }

  end

  def insert
    col_names = self.class.columns
    joined_col_names = col_names.join(',')
    question_marks = (["?"] * col_names.length).join(',')
    # debugger

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{joined_col_names})
      VALUES
        (#{question_marks})
    SQL

    self.send(:id=, DBConnection.last_insert_row_id)
  end

  def update
    set_line = self.class.columns.map { |col| "#{col} = ?" }.join(',')

    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL
  end

  def save
    id ? update : insert
  end
end
