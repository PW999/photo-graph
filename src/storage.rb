# frozen_string_literal: true

require 'sqlite3'
require_relative 'log_config'

class Storage
  COMMIT_EVERY = 25

  def initialize(name)
    @log = Logging.logger[self]

    @log.info "Opening SQLite database #{name}.db"
    @db = SQLite3::Database.open "#{name}.db"
    @db.results_as_hash = true

    @log.debug 'Creating table photos if not exists'
    @db.execute <<-SQL
      create table if not exists photos (
        id integer primary key autoincrement,
        full_path varchar(2048) not null unique,
        file_name varchar(512) not null,
        ts_taken varchar(30) not null,
        date_taken varchar(10) not null
      )
    SQL

    @log.debug 'Creating index on date_take if not exists'
    @db.execute <<-SQL
      create index if not exists photos_date_taken on photos(date_taken)
    SQL

    @has_transaction = false
    @in_transaction_count = 0
  end

  def store(data)
    start_transaction_if_necessary

    id_to_update = @db.get_first_value 'select id from photos where full_path = ?', data.full_path
    @in_transaction_count += 1
    if id_to_update.nil?  # it's a fresh insert
      insert_data = data.to_a
      @log.debug "Inserting #{insert_data}"
      @db.execute 'insert into photos(full_path, file_name, ts_taken, date_taken) values (?, ?, ?, ?)', insert_data
    else
      update_data = []
      update_data << data.to_a
      update_data << id_to_update
      @log.debug "Updating #{update_data}"
      @db.execute 'update photos set full_path = ?, ts_taken = ?, ts_taken = ?, date_taken = ? where id = ?', update_data
    end

    commit_if_necessary
  end

  def grouped_by_date
    data_a = []
    rs = @db.query 'select date_taken, count(date_taken) as count from photos group by date_taken order by date_taken asc'
    rs.each { |result| data_a << result }
    rs.close
    data_a
  end

  def get_by_path_as_hash(path)
    commit_if_has_transaction
    @db.get_first_row 'select * from photos where full_path = ?', path
  end

  def start_transaction_if_necessary
    return if @has_transaction

    @log.debug 'Starting transaction'
    @db.transaction(:immediate)
    @in_transaction_count = 0
    @has_transaction = true
  end

  def commit_if_necessary
    return unless (@in_transaction_count % COMMIT_EVERY).zero?

    @log.debug 'Committing to DB'
    @db.commit
    @has_transaction = false
    @in_transaction_count = 0
  end

  def commit_if_has_transaction
    return unless @has_transaction

    @log.debug 'Committing to DB'
    @db.commit
    @has_transaction = false
    @in_transaction_count = 0
  end
end
