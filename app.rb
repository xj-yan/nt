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

  helpers  Sinatra::JSON
  register Sinatra::Partial
  register Sinatra::Flash
  register Sinatra::Contrib
  helpers Timeline
  helpers Authentication

  set :root,                    File.dirname(__FILE__)
  set :views,                   Proc.new { File.join(root, "app/views") }
  set :public_folder,           Proc.new { File.join(root, "public")}
  set :partial_template_engine, :erb
  set :bind,                    '0.0.0.0'

  enable :sessions, :partial_underscores

  configure :production do
    enable :logging
  end
  
  # run!
end
