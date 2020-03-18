require "sinatra/base"
require "json"

require_relative "./app/routes/home"
require_relative "./app/routes/test"
require_relative "./app/routes/timeline"
require_relative "./app/routes/user"

class App < Sinatra::Base

  set :views,                   Proc.new { File.join("./", "app/views") }

  run!
end