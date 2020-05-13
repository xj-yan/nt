# Add your unit tests.
# You want to test your interaction with the database here.
# ENV['APP_ENV'] = 'development'
# ENV['DB_HOST'] = 'gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com'
# ENV['DB_PASSWORD'] = 'iyajy1kgp2nczrpi'

require_relative '../app'

require 'minitest/autorun'
require 'rack/test'
require 'test/unit'
require 'sinatra/base'

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

  # def register_path
  #   post '/register', params={:username => "test1", :email => "1234@example.com", :password => "123"}
  #   assert_equal 200, last_response.status
  # end
end

# # describe 'The HelloWorld App' do
# #   it "says hello" do
# #     get '/'
# #     last_response.ok?
# #     last_response.body.must_equal 'Hello Sinatra!'
# #   end
# # end

# # describe "GET on /api/users/:name" do
# #   before do
# #     User.delete_all
# #     User.create(
# #       name: "paul",
# #       email: "paul@gmail.com",
# #       password: "foo",
# #       bio: "Student")
# #   end

# #   it "Should return user by name" do
# #     get '/api/users/paul'
# #     last_response.ok?
# #     attributes = JSON.parse(last_response.body)
# #     attributes["name"].must_equal "paul"
# #   end

# #   it "Should return users email too" do
# #     get '/api/users/paul'
# #     last_response.ok?
# #     attributes = JSON.parse(last_response.body)
# #     attributes["email"].must_equal "paul@gmail.com"
# #   end

# #   it "Should not return user password" do
# #     get '/api/users/paul'
# #     last_response.ok?
# #     attributes = JSON.parse(last_response.body)
# #     attributes.key?("password").must_equal false
# #   end
# # end


# describe "POST on /api/user" do
#   before do
#     #User.delete_all
#   end

#   it "Should create a user" do
#     uri = URI.parse("http://0.0.0.0:4568/user/register")
#     uri.query = URI.encode_www_form(
#       [["name", "test_foo"], 
#        ["email", "test_foo1@gmail.com"],
#        ["password", "testpassword"]])
#     puts uri.to_s
#     post uri.to_s
#     last_response.status.must_equal 200

#     uri = URI.parse("http://0.0.0.0:4568/user/validate")
#     uri.query = URI.encode_www_form(
#       [["email", "test_foo1@gmail.com"],
#        ["password", "testpassword"]])
#     puts uri.to_s
#     post uri.to_s
#     last_response.ok?
#     attributes = JSON.parse(last_response.body)
#     attributes["status"].must_equal "success"
#   end
# end

