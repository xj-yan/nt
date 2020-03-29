# using Rack handler, run config.ru command: rackup -p 4567
# require './app'
# require './config/environment'
ENV['ROOT_PATH'] = "#{File.expand_path(File.dirname(__FILE__))}"

require 'config/environment'
run App
