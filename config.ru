# using Rack handler, run config.ru command: rackup -p 4567
# require './app'
# require './config/environment'
$:.unshift(File.dirname(__FILE__))

require 'boot'
run App
