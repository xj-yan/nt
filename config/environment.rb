ENV['APP_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['APP_ENV'])

ActiveRecord::Base.establish_connection(ENV['APP_ENV'].to_sym)

require_all 'app'