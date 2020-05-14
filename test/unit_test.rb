require_relative '../app'

require 'minitest/autorun'
require 'rack/test'
require 'test/unit'
require 'sinatra/base'
require 'json'

class UnitTestClass < Test::Unit::TestCase
  include Rack::Test::Methods
  def app
    App
  end

  def test_root_path
    get '/'
    assert_equal 302, last_response.status
    assert !last_response.ok?
  end

  def test_login_path
    get '/login'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end 

  def test_with_proper_credentials_path
    authorize 'testuser@sample.com', 'password'
    get '/login'
    assert_equal 200, last_response.status
  end

  def register_path
    get '/register'
    assert_equal 200, last_response.status
  end


end




