class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    default_params.permit(:name, :email, :password, :password_confirmation)
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  #include SessionsHelper
  
  protected

  	 def devise_parameter_sanitizer
    	if resource_class == User
      	User::ParameterSanitizer.new(User, :user, params)
    	else
      	super # Use the default one
    	end
  	end 
end
