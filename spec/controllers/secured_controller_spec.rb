require 'spec_helper'

describe SecuredsController do
	describe "GET #index"	do
		it "populates array of Secureds" do
			secured = FactoryGirl.create(:secured)
			get :index
			assigns(:secureds).should eq([secured])
		end	
		it "renders the :index view" do
			get :index
			response.should render_template :index
		end	
	end
	
	describe "GET #show" do
		it "assigns requested secured to @secured" do
			secured = FactoryGirl.create(:secured, live: true)
			get :show, id: secured.review_url
			assigns(:secured).should eq(secured)
		end	

		it "renders the #show view" do
			secured = FactoryGirl.create(:secured, live: true)
			get :show, id: secured.review_url			
			response.should render_template :show
		end
	end

end