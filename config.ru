require './application'

use Rack::PostBodyContentTypeParser

run Application.new

