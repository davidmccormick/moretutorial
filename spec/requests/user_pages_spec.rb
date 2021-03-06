require 'spec_helper'

describe "User Pages" do

	let(:base_title) {"Ruby on Rails Tutorial Sample App"}
	
	subject { page }
	
	describe "as a non admin user" do
				let(:user) { FactoryGirl.create(:user) }
				let(:non_admin) { FactoryGirl.create(:user) }

				before { sign_in_req non_admin}
			
				describe "submitting a DELETE request to the Users#destroy action" do
					before { delete user_path(user) }
					specify { 
					response.should redirect_to(root_path) }
				end
		end
	
		describe "delete links" do
			it { should_not have_link('delete') }
			
			describe "as an admin user" do
				let(:admin) {FactoryGirl.create(:admin) }
				
				before do
					sign_in_req admin
				end
			
				describe "an admin should not be able to destroy themselves" do
					it "shouldn't be able to delete itself" do
						expect {  delete user_path(admin) }.to_not change(User, :count)
					end
				end
			end
		end
end
