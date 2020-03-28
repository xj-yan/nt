require "sinatra/base"
require "json"

require_relative 'config/environment'
require_relative "./app/routes/home"
require_relative "./app/routes/testinterface"
require_relative "./app/routes/user"
require_relative "./app/routes/tweet"

require_relative "./app/models/user"

require_relative "./app/helpers/timeline"
require_relative "./app/helpers/authentication"

class App < Sinatra::Base

  set :views,                   Proc.new { File.join("./", "app/views") }
  set :public_folder,           Proc.new { File.join("./", "public")}

  run!
end