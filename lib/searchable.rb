require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?" }.join(' AND ')
    vals = params.values

    results = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL

    results.map { |row| self.new(Hash[row.map{|k,v|[k.to_sym, v]}]) }
  end
end

class SQLObject
  extend Searchable
end
