require "sinatra/base"
require "json"

require_relative 'config/environment'
require_relative "./app/routes/home"
require_relative "./app/routes/test"
require_relative "./app/routes/timeline"
require_relative "./app/routes/user"
require_relative "./app/models/user"

class App < Sinatra::Base

  set :views,                   Proc.new { File.join("./", "app/views") }

  run!
end