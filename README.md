# hide_and_sql

## Summary

hide_and_sql is a lightweight Object Relational Mapping (ORM) tool.

Inspired by ActiveRecord, hide_and_sql can easily perform database operations
using Ruby class objects to represent tables in the database. These classes
provide a user-friendly interface to manipulate data and define relationships
between different tables.

## Setup

- Download or clone hide_and_sql into your working folder
- Change the following paths in `lib/db_connection.rb` to point to your database
files:

```ruby
SQL_FILE = File.join(ROOT_FOLDER, 'YOUR_SQL_FILE.sql')
DB_FILE = File.join(ROOT_FOLDER, 'YOUR_DB_FILE.db')
```

- Create Ruby classes, inherited from `SQLObject`, to represent your SQL tables
- Use the singular, CamelCase version of your table names when naming your
classes (or use the `::table_name=` method to set the name manually)
- Call the `::finalize!` method at the end of your class definitions to create
getter and setter methods

## Example

```ruby
class House < SQLObject
  has_many :voters
  has_many :votes, through: :voters

  finalize!
end
```

```ruby
class Voter < SQLObject
  belongs to :house
  has_many :votes

  finalize!
end
```

```ruby
class Vote < SQLObject
  belongs_to :voter
  has_one :house, through: :voter
end
```

## API

### Class Methods

- `::columns` Returns all table columns
- `::finalize!` Creates getter and setter methods for each column
- `::table_name=(name)` Sets instance variable to name of table
- `::table_name` Returns name of table
- `::all` Returns all rows from table
- `::find(id)` Returns row with given id

### Instance Methods

- `#attributes` Returns row's values
- `#insert` Inserts object into new row in table
- `#update` Edits values of the object in the table
- `#save` Calls `#update` when object has id, `#save` when it doesn't

### Associations

- `belongs_to`
- `has_many`
- `has_one_through`
