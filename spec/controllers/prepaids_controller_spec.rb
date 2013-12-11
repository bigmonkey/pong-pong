require 'spec_helper'

describe PrepaidsController do
	describe "GET #index"	do
		it "populates array of Prepaids" do
			prepaid = FactoryGirl.create(:prepaid)
			get :index
			assigns(:prepaids).should eq([prepaid])
		end	
		it "renders the :index view" do
			get :index
			response.should render_template :index
		end	
	end
	
	describe "GET #show" do
		it "assigns requested prepaid to @prepaid" do
			prepaid = FactoryGirl.create(:prepaid, live: true)
			get :show, id: prepaid.review_url
			assigns(:prepaid).should eq(prepaid)
		end	

		it "renders the #show view" do
			get :show, id: FactoryGirl.create(:prepaid)
			response.should render_template :show
		end
	end

end