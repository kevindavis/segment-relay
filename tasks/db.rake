namespace :db do

  desc "create events table in the database"
  task :create do |t, args|

    connection_hash = {
      host: ENV['ANALYSIS_DB_HOST'],
      dbname: ENV['ANALYSIS_DB_DBNAME'],
      user: ENV['ANALYSIS_DB_USER'],
      password: ENV['ANALYSIS_DB_PW']
    }
    db = PG.connect(connection_hash)

    events_schema = 'user_id text,'\
                    'event_name text,'\
                    'details json,'\
                    'occurred_at timestamp'
    
    begin
      db.exec 'CREATE TABLE IF NOT EXISTS events(' + events_schema + ')'
    rescue
      puts "There was a problem creating the events table"
    else
      puts "Created the events table"
    end
  end

end