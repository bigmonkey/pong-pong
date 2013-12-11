require 'spec_helper'

describe PartnersController do
	describe "GET #show" do
		it "renders the :show view" do
			get :show, id: FactoryGirl.create(:partner)
			response.should render_template :show
		end
		it "assigns a lender url with no tail" do
			#default tracking values
			get :show, id: FactoryGirl.create(:partner, lender_link: "http://lender-link.com")
			assigns(:lender_url).should eq('http://lender-link.com')
		end

		it "assigns a lender url with a tail" do
			#default tracking values
			page="0000"
			source="0000"
			get :show, id: FactoryGirl.create(:partner, lender_link: "http://lender-link.com", lender_tail: "?tail=")
			assigns(:lender_url).should eq('http://lender-link.com?tail=' + page + source)
		end
	end
end