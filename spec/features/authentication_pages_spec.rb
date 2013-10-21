require 'spec_helper'

describe "Authentication" do
	subject { page}
	describe "#signin page" do
		before { visit new_user_session_path }

		it "has css \"title\" with text \"Sign In\"" do
			expect(page).to have_selector('h1', text: "Sign In")
			expect(page).to have_title("Sign In")
		end
	end

	describe "when signing in" do
		before { visit new_user_session_path }

		context "with invalid credentials" do
			before { click_button "Sign In" }

			it "we get redirected and an error flash" do
				expect(page).to have_title('Sign In')
				expect(page).to have_selector('div.alert', text: 'Invalid')
			end

			describe "then visiting another page" do
				before { click_link 'Home' }

				it "doesn't have an error flash" do
					expect(page).to_not have_selector('div.alert')
				end
			end
		end

		context "with valid credentials" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				click_button "Sign In"
			end

			it "has right content and links" do
				expect(page).to have_title(user.name)
				expect(page).to have_link('Profile', href: user_path(user))
				expect(page).to have_link('Settings', href: edit_user_registration_path)
				expect(page).to have_link('Sign out', href: destroy_user_session_path)
				expect(page).to_not have_link('Sign in', href: new_user_session_path)
			end

			describe "then if we sign out" do
				before { click_link ('Sign out') }

				it "has the right links" do
					save_and_open_page
					expect(page).to have_link('Sign in')
					expect(page).to_not have_link('Profile')
					expect(page).to_not have_link('Settings')
					expect(page).to_not have_link('Sign out')
				end
			end
		end
	end
	
	describe "when attempting to visit a protected page" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			visit edit_user_registration_path
			fill_in "Email", with: user.email
			fill_in "Password", with: user.password
			click_button "Sign In"
		end

		describe "after signing in" do
			it "should render the desired protected page" do
				save_and_open_page
				expect(page).to have_title('Edit User')
			end
		end
	end
end
