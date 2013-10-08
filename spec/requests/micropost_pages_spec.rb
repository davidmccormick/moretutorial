require 'spec_helper'

describe "Micropost pages" do
	
	subject { page }
	
	let(:user) { FactoryGirl.create(:user) }
	before { sign_in_req user }
	
	describe "micropost destruction" do
		let!(:post) { FactoryGirl.create(:micropost, user: user) }
		let(:wrong_user) { FactoryGirl.create(:user) }	
		
		context "as the wrong user" do
			before { 
				sign_in_req wrong_user
				delete micropost_path(post)
				# Note this is rack test - not capybara!!
			}
			it "should redirect to the root path" do
				expect(response).to redirect_to(root_path)
			end
			it "should have an error flash" do
				follow_redirect!
				expect(response.body).to include("You are not allowed to destroy microposts that you do not own!")
			end
		end
	end
end
