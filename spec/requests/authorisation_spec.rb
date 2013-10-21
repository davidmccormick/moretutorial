require 'spec_helper'

describe "Authorization" do
	context "with non-signed in users" do
		let(:user) { FactoryGirl.create(:user) }

		describe "In the users controller" do
			describe "when visiting the edit page" do
				before { visit edit_user_path(user) }
				it "is the Sign In page" do
					expect(page).to have_title("Sign in")
				end
			end

			describe "when submitting the update action" do
				before { put user_path(user) }
				it "redirects you to the Sign In page" do
					 expect(response).to redirect_to(new_user_session_path)
				end
			end

			describe "when visiting the user index" do
				before { visit users_path }
				it "it is the Sign in page" do
					expect(page).to have_title('Sign in')
				end
			end

			describe "visiting the following page" do
				before { visit following_user_path(user) }
				it "redirects you to the Sign In page" do
					expect(page).to have_title('Sign in')
				end
			end

			describe "visiting the followers page" do
				before { visit followers_user_path(user) }
				it "redirects you to the Sign In page" do
					expect(page).to have_title('Sign in')
				end
			end

			describe "in the Relationship controller" do
				describe "submitting to the create action" do
					before { post relationships_path }
					specify { response.should redirect_to(new_user_session_path) }
				end

				describe "submitting the destroy action" do
					before { delete relationship_path(1) }
					specify { response.should redirect_to(new_user_session_path) }
				end
			end
		end
	end
	
	context "as wrong user" do
		let(:user) { FactoryGirl.create(:user) }
		let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

		before { sign_in_req user }

		describe "visiting Users#edit page" do
			before { visit edit_user_path(wrong_user) }
			it "is not the edit page" do
				expect(page).to_not have_title(full_title('Edit user'))
			end
		end
		describe "submitting a put request to the users#update action" do
			before { put user_path(wrong_user) }
			specify { expect(response).to redirect_to(root_path) }
		end
	end

	describe "microposts controller" do
		context "when not signed in" do
			describe "posting to create" do
				before {  post microposts_path }
				specify { expect(response).to redirect_to(new_user_session_path) }
			end

			describe "deleting to destroy" do
				before {
					micropost = FactoryGirl.create(:micropost)
					delete micropost_path(micropost)
				}
				it { expect(response).to redirect_to(new_user_session_path) }
			end
		end
	end
end

