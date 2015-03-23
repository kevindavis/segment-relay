# connection_hash = {
#   host: ENV['ANALYSIS_DB_HOST'],
#   dbname: ENV['ANALYSIS_DB_DBNAME'],
#   user: ENV['ANALYSIS_DB_USER'],
#   password: ENV['ANALYSIS_DB_PW']
# }
db = PG.connect(ENV['DATABASE_URL'])

namespace :db do
  desc 'create events table in the database'
  task :create do
    col_type = 'jsonb'
    col_type = 'json' if db.parameter_status('server_version').to_f < '9.4'.to_f
    events_schema = 'user_id text,'\
                    'event_name text,'\
                    "details #{col_type},"\
                    'occurred_at timestamp'

    begin
      db.exec "CREATE TABLE IF NOT EXISTS events( #{events_schema} )"
    rescue PG::Error => err
      puts "There was a problem creating the events table: #{err.message}"
    else
      puts 'Created the events table'
    end
  end

  desc 'destroy the events table in the database'
  task :drop do
    begin
      db.exec 'DROP TABLE events'
    rescue
      puts 'There was a problem destroying the events table'
    else
      puts 'Destroyed the events table'
    end
  end

  desc 'empty the events table'
  task :empty do
    begin
      db.exec 'DELETE FROM events'
    rescue
      puts 'There was a problem emptying the events table'
    else
      puts 'Emptied the events table'
    end
  end
end
