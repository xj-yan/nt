# endpoint related to user

class App < Sinatra::Base

  # routes for logged in user
	# get "/user/profile" do
	# 	authenticate!
	# 	erb :profile_page, locals: {user: params}
	# end

	get "/user/:id" do
		# get page count
		# count = params[:n].to_i || 1
		authenticate!
		id = params[:id]
		@user = User.find(id)
		@timeline = get_user_timeline(id)
		# @timeline = get_tweet_list(id, count)
		# @is_follow = Follow.find_by(followee_id: id, follower_id: session[:user_id]).nil?
		if @user.nil?
			return 404
		else
			# erb :user_main_page
			# erb :user
			erb :profile
		end
	end

	get '/:id/follower' do
		user_id = User.find(params[:id]).id
		following_user = Array.new
		Follow.where(followee_id: user_id).each do |f|
			following_user << {id: f.follower_id, username: User.find(f.follower_id).username}
		end
		return following_user.to_json
		# return User.find(params[:id]).username.to_json
	end

	get '/:id/following' do
		user_id = User.find(params[:id]).id
		follower_user = Array.new
		Follow.where(follower_id: user_id).each do |f|
			follower_user << {id: f.followee_id, username: User.find(f.followee_id).username}
		end
		return follower_user.to_json
		# return User.find(params[:id]).username
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

	get '/api/user' do
		authenticate!
		act = params[:act]
		if act == 'get_home_user'
			get_name(session[:user_id]).to_json
		elsif act == 'get_home_id'
			session[:user_id].to_json
		end
	end
end