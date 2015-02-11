connection_hash = {
  host: ENV['ANALYSIS_DB_HOST'],
  dbname: ENV['ANALYSIS_DB_DBNAME'],
  user: ENV['ANALYSIS_DB_USER'],
  password: ENV['ANALYSIS_DB_PW']
}
db = PG.connect(connection_hash)

namespace :db do

  desc "create events table in the database"
  task :create do |t, args|

    json_type = 'jsonb'
    json_type = 'json' if db.parameter_status('server_version').to_f < "9.4.0".to_f
    events_schema = 'user_id text,'\
                    'event_name text,'\
                    "details #{json_type},"\
                    'occurred_at timestamp'
    
    begin
      db.exec "CREATE TABLE IF NOT EXISTS events( #{events_schema} )"
    rescue PG::Error => err
      puts "There was a problem creating the events table: #{err.message}"
    else
      puts "Created the events table"
    end
  end

  desc "destroy the events table in the database"
  task :drop do |t, args|
    begin
      db.exec 'DROP TABLE events'
    rescue
      puts "There was a problem destroying the events table"
    else
      puts "Destroyed the events table"
    end
  end

  desc "empty the events table"
  task :empty do |t, args|
    begin
      db.exec 'DELETE FROM events'
    rescue
      puts 'There was a problem emptying the events table'
    else
      puts 'Emptied the events table'
    end
  end
end