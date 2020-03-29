# using Rack handler, run config.ru command: rackup -p 4567
# require './app'
require './config/environment'
set :root,                    File.dirname(__FILE__)
run App