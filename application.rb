require "rubygems"
require "bundler"
require "pg"
require "rack"
require "rack/contrib"
Bundler.require :default, (ENV["RACK_ENV"] || "development").to_sym

class Application < Sinatra::Base

  configure :production, :development do
    enable :logging
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

  post "/segment" do
    logger.info params
    begin
      @db.exec("INSERT INTO events (          \
                              event_name,     \
                              occurred_at,    \
                              user_id,        \
                              details         \
                ) VALUES (                    \
                    #{params[:event]},       \
                    #{params[:timestamp]},   \
                    #{params[:userId]},      \
                    #{params[:properties]}   \
                )")
    rescue PG::Error => err
      logger.error "Problem inserting an event (#{params[:event]}) at #{params[:timestamp]}"
    end
  end

end