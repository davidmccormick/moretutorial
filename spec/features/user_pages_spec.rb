require 'spec_helper'

describe "User Pages" do

	let(:base_title) {"Ruby on Rails Tutorial Sample App"}
	
	subject { page }
	
	describe "index" do
		
		before(:each) do
			sign_in_capy FactoryGirl.create(:user)
			visit users_path
		end
		
		after(:each) { sign_out_capy }
		
		it { should have_title("All users") }
		it { should have_selector('h1', text: "All users") }
		
		describe "pagination" do
			before do 
				30.times do
					FactoryGirl.create(:user)
				end
				visit users_path
			end
			
			it { should have_selector('div.pagination') }
			
			it "should list each user" do
				User.paginate(page: 1).each do |user|
					page.should have_selector('li', text: user.name)
				end
			end
			
			after do
				User.delete_all
			end
		end
		
		describe "delete links" do
			it { should_not have_link('delete') }
			
			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				
				before do
					sign_out_capy
					#puts "admin user is #{admin.name}"
					sign_in_capy admin
					#puts "#{page.body}"
					visit users_path
				end
				
				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(:admin)) }
		
			end
		end
	end
	
  describe "Signup page" do
  	before { visit new_user_registration_path }
  	
    it { should have_selector('h1', :text => 'Sign Up') }
    it { should have_title("#{base_title} | Sign Up" ) }
  end
  
  describe "signup" do
  	before { 
		visit new_user_registration_path
	}
  	
  	let(:submit) { "Sign up" }
  	
  	describe "with invalid information" do
  		it "should not create a user" do
  			expect { click_button submit }.not_to change(User, :count)
  		end
  		
  		describe "after submission" do
  			before { click_button submit }
  			
  			it { should have_title('Sign Up') }
  			it { should have_content('error') }
  		end
  	end
  	
  	describe "with valid information" do
  		before do
  			fill_in "Name", with: "Example User"
  			fill_in "Email", with: "user@example.com"
  			fill_in "Password", with: "foobar"
  			fill_in "Password confirmation", with: "foobar"
  		end
  		
  		it "should create a user" do
  			expect { click_button submit }.to change(User, :count).by(1)
  		end 
  	
  		describe "after saving the user" do
  			before { click_button submit }
  			it { should have_selector('div.alert.alert-notice', text: "A message with a confirmation link has been sent to your email address.") }
  		end
  	end
  end
  
  describe "Profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
  	let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
  	before { visit user_path(user) }
  	
  	it { should have_selector('h1', text: user.name) }
  	it { should have_title(user.name) }
  	
  	describe "microposts" do
  		it { should have_content(m1.content) }
  		it { should have_content(m2.content) }
  		it { should have_content(user.microposts.count) }
  	end
  	
  	describe "follow/unfollow butons" do
  		let(:other_user) { FactoryGirl.create(:user) }
  		before { sign_in_capy user }
  		
  		describe "following a user"do
  			before { visit user_path(other_user) }
  			
  			it "should incremement the followed user count" do
  				expect {
  					click_button "Follow"
  				}.to change(user.followed_users, :count).by(1)
  			end
  			
  			it "should incremement the other users' follower count" do
  				expect {
  					click_button "Follow"
  				}.to change(other_user.followers, :count).by(1)
  			end
  			
  			describe "toggling the button" do
  				before { click_button "Follow" }
  				
  				it { 
  					should have_button('Unfollow')
  					#have_selector("input[type=submit][name=commit][value='Unfollow']")
  					
  					 }
  			end
  		end
  		
  		describe "unfollowing a user" do
  			before do
  				user.follow!(other_user)
  				visit user_path(other_user)
  			end
  			
  			it "should decrement the following user count" do
  				expect { click_button "Unfollow" }.to change(user.followed_users, :count).by(-1)
  			end
  			
  	  		it "should decrement the other users followers count" do
  				expect { click_button "Unfollow" }.to change(other_user.followers, :count).by(-1)
  			end
  			
  			describe "toggling the follow button" do
  				before { click_button "Unfollow" }
  				it { should have_button('Follow') }
  			end
  		end
  	end
  end 
  
  describe "edit" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
  		sign_in_capy user
  		visit edit_user_registration_path(user)
  	end
  	
  	describe "page" do
  		it { should have_selector('h1', text: "Update your profile") }
  		it { should have_title("Edit user") }
  		it { should have_field('Email', with: user.email) }
  		it { should have_link('change', href: 'http://gravatar.com/emails') }
  	end
  	
  	describe "with invalid information" do
  		before { click_button "Save changes" }
  		
  		it { should have_content('error') }
  	end
  	
  	describe "with valid information" do
  		let(:new_name) { "New Name" }
  		let(:new_email) { "new@example.com" }
  		
  		before do
  			fill_in "Name", with: new_name
  			fill_in "Email", with: new_email
  			fill_in "Password", with: user.password
  			fill_in "Confirm Password", with: user.password
  			fill_in "Current Password", with: user.password
  			click_button "Save changes"
  		end
  		

  		it { should have_selector('div.alert', text: "You updated your account successfully") }
  		it {
				should have_link('Sign out', href: destroy_user_session_path) 
		}
  		specify { user.reload.name.should == new_name }
  		specify { user.reload.unconfirmed_email.should == new_email }
  	end
  end
  
  describe "following/followers" do
  	let(:user) { FactoryGirl.create(:user) }
  	let(:other_user) { FactoryGirl.create(:user) }
  	before { user.follow!(other_user) }
  	
  		describe "followed users" do
  			before do
  				sign_in_capy user
  				visit following_user_path(user)
  			end
  		
  			it { should have_title(full_title('Following')) }
  			it { should have_selector('h3', text: 'Following') }
  			it { should have_link(other_user.name, href: user_path(other_user)) }
  		end
  	
  		describe "followers" do
  			before do
  				sign_in_capy other_user
  				visit followers_user_path(other_user)
  			end
  		
   		it { should have_title(full_title('Followers')) }
  			it { should have_selector('h3', text: 'Followers') }
  			it { should have_link(user.name, href: user_path(user)) }
  		end
  	end
end
