require 'spec_helper'

feature "Micropost pages" do
	
	subject { page }
	
	let(:user) { FactoryGirl.create(:user) }
	before { sign_in_capy user }
	
	describe "micropost creation" do
		before { visit root_path }
		
		context "with invalid information" do
			scenario "should not create an empty micropost" do
				expect { click_button "Post" }.to_not change(Micropost, :count)
			end
			
			describe "error message" do
				before  { click_button "Post" }
				
				scenario "should render an error message" do
					expect(page).to have_content('error')
				end
			end
		end
		
		context "with valid post" do
			before { fill_in 'micropost_content', with: "Lorem Ipsum" }
			scenario "creates the micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
				expect(page).to have_selector("div.alert.alert-success", text: "Micropost Created")
			end
		end
	end
	
	describe "micropost destruction" do
		let!(:post) { FactoryGirl.create(:micropost, user: user) }
		let(:wrong_user) { FactoryGirl.create(:user) }	
		
		context "as the correct user"  do
			before { visit root_path }
		
			scenario "should delete a micropost" do
				expect { click_link  "delete" }.to change(Micropost, :count).by(-1)
			end
		end
	end
end
