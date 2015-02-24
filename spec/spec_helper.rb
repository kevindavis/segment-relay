require 'rack/test'
require 'rspec'

require File.expand_path '../../application.rb', __FILE__

ENV['RACK_ENV'] = 'test'

# mixed into every test file
module RSpecMixin
  include Rack::Test::Methods
  def app
    Application
  end
end

RSpec.configure { |c| c.include RSpecMixin }
