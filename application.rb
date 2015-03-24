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
  end

  def initialize
    uri = URI.parse(ENV['DATABASE_URL'])
    
    begin
      @db = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    rescue
      puts 'Problem connecting to Postgres. Exiting.'
      exit
    end

    super
  end

  post '/' do
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
