require 'rubygems'
require 'bundler'
require 'pg'
require 'rack'
require 'rack/contrib'
require 'json'
Bundler.require :default, (ENV['RACK_ENV'] || 'development').to_sym

# Basic Sinatra app that takes posts to /segment and inserts them in a PG DB
class Application < Sinatra::Base
  configure :production, :development do
    enable :logging
    set :server, :puma
  end

  def initialize
    connection_hash = {
      host: ENV['ANALYSIS_DB_HOST'],
      dbname: ENV['ANALYSIS_DB_DBNAME'],
      user: ENV['ANALYSIS_DB_USER'],
      password: ENV['ANALYSIS_DB_PW']
    }
    @db = PG.connect(connection_hash)
  end

  post '/segment' do
    if params[:type] == 'track'
      begin
        @db.exec("INSERT INTO events (                  \
                                event_name,             \
                                occurred_at,            \
                                user_id,                \
                                details                 \
                  ) VALUES (                            \
                      '#{params[:event]}',              \
                      '#{params[:timestamp]}',          \
                      '#{params[:userId]}',             \
                      '#{params[:properties].to_json}'  \
                  )")
      rescue PG::Error => err
        logger.error "Problem with (#{params[:event]}) @#{params[:timestamp]}"
        logger.error err.message
      end
    end
  end
end
