require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?" }.join(' AND ')
    vals = params.values
    # debugger

    results = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        (#{where_line})
    SQL
    # debugger
    results.map { |row| self.new(Hash[row.map{|k,v|[k.to_sym, v]}]) }
    # debugger
  end
end

class SQLObject
  extend Searchable
end
