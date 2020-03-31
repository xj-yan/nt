# endpoint related to user

class App < Sinatra::Base

  # routes for logged in user
	get "/user/profile" do
			authenticate!
			erb :profile_page, locals: {user: params}
	end

	get "/user/:id" do
			authenticate!
			@user = User.find(params[:id])
			if @user.nil?
				return 404
			else
				erb :user_main_page
			end
	end

	post '/follow/:id' do
			authenticate!
			Follow.create(
					follower_id: session[:user_id], 
					followee_id: params[:id]
			)
			User.increment_counter(:followee_number, session[:user_id])
			User.increment_counter(:follower_number, params[:id])
			return 200
	end

	post '/unfollow/:id' do
			authenticate!
			Follow.find_by(follower_id: session[:user_id], followee_id: params[:id]).delete
			User.decrement_counter(:followee_number, session[:user_id])
			User.decrement_counter(:follower_number, params[:id])
			return 200
	end

	get '/name' do
		authenticate!
		puts "print"
		act = params[:act]
		if act == 'get_home_user'
			name = get_name(session[:user_id])
		end
	end
end