require 'sinatra/base'
require 'bcrypt'

module Authentication
  def authenticate!
    unless session[:user_id]
      flash[:notice] = "You are not logged in!"
      # redirect '/login'
      redirect '/index'
    end
  end

  def redirect_to_original_request
    user = session[:user]
    flash[:notice] = "Welcome back #{user.name}."
    original_request = session[:original_request]
    session[:original_request] = nil
    redirect original_request
  end

  def test_password(password, hash)
    BCrypt::Password.new(hash) == password
  end

  def hash_password(password)
    BCrypt::Password.create(password).to_s
  end

end