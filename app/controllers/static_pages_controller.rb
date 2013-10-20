class StaticPagesController < ApplicationController
	#before_filter :authenticate_user!
	
	def home
		if user_signed_in?
			@micropost = current_user.microposts.build
			@feed_items = current_user.feed.paginate(page: params[:page])
		end
	end

	def help
	end
  
	def about
	end
  
	def contact
	end
end
