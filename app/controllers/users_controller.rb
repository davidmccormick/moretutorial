class UsersController < ApplicationController
	include UsersHelper
	#before_filter :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy
	before_filter :authenticate_user!, only: [:edit, :update, :index, :destroy, :following, :followers]

	def index
		@users = User.order('name ASC').paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end
  
	# NOW CREATED IN THE DEVISE CONTROLLER
	#def new
	#		@user = User.new
	#end
  
	#def create
		#@user = User.new(user_params)
		#if @user.save
			##sign_in @user
			#flash[:success] = "Please confirm your email address and then sign in!"
			#redirect_to root_path
		#else
			#render 'new'
		#end
	#end
  
	def destroy
  		user = User.find(params[:id])
  		if ( user != current_user )
  			user.destroy
  			flash[:success] = "User Destroyed"
  			redirect_to users_path
  		else
  			flash[:error] = "You shouldn't try to destory yourself!"
  			redirect_to root_path
  		end
	end
  
	# NOW EDITED IN THE DEVISE CONTROLLER
	#def edit
		#removed because this is done in correct_user before_filter 
		#@user = User.find(params[:id])
	#end
  
	#def update
	#	#removed because this is done in correct_user before_filter 
		#@user = User.find(params[:id])
		#if @user.update_attributes(user_params).skip_confirmation!
		#	flash[:success] = "Profile updated"
		#	sign_in @user, :bypass => true
		#	redirect_to @user
		#else
		#	render 'edit'
		#end
	#end
  
	def following
  		@title = "Following"
  		@user = User.find(params[:id])
  		@users = @user.followed_users.paginate(page: params[:page])
  		render 'show_follow'
	end
  
	def followers
  		@title = "Followers"
  		@user = User.find(params[:id])
  		@users = @user.followers.paginate(page: params[:page])
  		render 'show_follow'
  	end
  
  private
  
  	def user_params
  		params.require(:user).permit(:email, :name, :password, :password_confirmation)
  	end
  	
  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_path) unless current_user?(@user)
  	end
  	
  	def admin_user
  		redirect_to root_path unless current_user.admin?
  	end
end
