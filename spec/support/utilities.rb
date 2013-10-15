	include ApplicationHelper
	
	def sign_in_capy(user)
		visit new_user_session_path
		fill_in "user[email]", with: user.email 
		fill_in "user[password]", with: user.password
		click_button "Sign In"
	end
	
	def sign_in_req(user)
		# Sign in when not using Capybara as well
		#cookies[:remember_token] = user.remember_token
	end
	
