class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def new
		if not session[:user_id].nil?
			redirect_to :controller => 'photos', :action => 'index', :id => session[:user_id]
		else
			@user = User.new
		end
	end

	def create
		if params[:user].nil?
			redirect_to :action => 'new'
		else
			@user = User.new user_params(params[:user])
			if @user.save
		    	flash[:notice] = "Congratulations, you are now registered!" 
		    	redirect_to :action => :login
			else
				flash[:error] = @user.errors.full_messages
				redirect_to :action => :new
		 	end
		 end
	end

	def login
		if not session[:user_id].nil?
			redirect_to :controller => 'photos', :action => 'index', :id => session[:user_id]
		end
	end

	def post_login
		if params[:user].nil?
			redirect_to :action => 'login'
		else
			@user = User.find_by_login(params[:user][:login])
			if not @user.nil? and @user.password_valid? params[:user][:password] 
				session[:user_id] = @user.id
				session[:user_name] = @user.first_name
				flash[:notice] = "Login successful!"
				redirect_to :controller => 'photos', :action => 'index', :id => @user.id.to_s
			else
				flash[:error] = "Login failed. Please try again."
				redirect_to :action => 'login'
			end
		end
	end

	def logout
		if not session[:user_id].nil?
			reset_session
			flash[:notice] = "Log out successful!"
		end
		redirect_to :action => 'login'
	end

	private
	def user_params(params)
		return params.permit(:first_name, :last_name, :login, :password, :password_confirmation)
	end
end
