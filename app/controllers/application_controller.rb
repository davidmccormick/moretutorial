class ApplicationController < ActionController::Base
	before_filter :configure_permitted_parameters, if: :devise_controller?
	after_filter :store_location
	protect_from_forgery
  
	protected

		def configure_permitted_parameters
		# Strong parameters
		# Allow the create and update forms to update the user.name attribute
			[ :sign_up, :account_update ].each { |hook|
				devise_parameter_sanitizer.for(hook) << :name
			}
		end 
		
		def after_sign_in_path_for(resource)
			session[:previous_url] || user_path(resource)
		end
	
		def redirect_back_or(default)
			redirect_to(session[:previous_url] || default)
			session.delete(:return_to)
		end
		
		def store_location
			# store last url as long as it isn't a /users path
			session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
		end
end
