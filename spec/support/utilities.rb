include ApplicationHelper

def sign_in_capy(user)
	visit new_user_session_path
	#puts "Signing in USER: #{user.name}"
	#puts page.body
	fill_in "user_email", with: user.email 
	fill_in "user_password", with: user.password
	click_button "Sign In"
end
	
# http://localhost:3000/users/sign_out
def sign_out_capy
	#puts "Signingout USER: #{user.name}"
	http_delete destroy_user_session_path
end
	
# Submit an HTTP delete request, using rack_test driver
def http_delete path
	current_driver = Capybara.current_driver
	Capybara.current_driver = :rack_test
	page.driver.submit :delete, path, {}
	Capybara.current_driver = current_driver
end
	
	
