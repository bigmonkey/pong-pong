require 'spec_helper'

describe "Admin Banners Controller" do
	describe "GET #index"	do
		it "populates array of Secureds" do
			banner = FactoryGirl.create(:banner)
			get admin_banners_path
			assigns(:banners).should eq([banner])
		end	
	end
	
	describe "GET #show" do
		it "assigns requested secured to @secured" do
#			secured = FactoryGirl.create(:secured, live: true)
#			get :show, id: secured.review_url
#			assigns(:secured).should eq(secured)
		end	

		it "renders the #show view" do
#			secured = FactoryGirl.create(:secured, live: true)
#			get :show, id: secured.review_url			
#			response.should render_template :show
		end
	end

end