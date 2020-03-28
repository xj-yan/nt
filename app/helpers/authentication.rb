require 'sinatra/base'
module Authentication
  def authenticate!
    unless session[:user_id]
      flash[:notice] = "You are not logged in!"
      redirect '/login'
    end
  end

  def redirect_to_original_request
    user = session[:user]
    flash[:notice] = "Welcome back #{user.name}."
    original_request = session[:original_request]
    session[:original_request] = nil
    redirect original_request
  end
end