require 'spec_helper'

describe Admin::BannersController do
	#render_views
	before(:each) do
		user =User.create!({
        :email => 'user@test.com',
        :password => 'happydoggy',
        :password_confirmation => 'happydoggy' 
        })
		sign_in user
	end

	describe "GET #index"	do
		it "renders the :index view" do
			get :index
			response.should render_template :index
		end	
	end
	
	describe "POST #create" do
		it "renders the :index view" do
			lender = FactoryGirl.create(:term_loan, partner: FactoryGirl.create(:partner), sniff_id: 2)
			banner = { name: lender.id, lender_link: 'http://test.com', lender_type: 'term'}
			post :create, banner: banner
			#binding.pry

			response.should redirect_to('/admin/banners/' + Banner.find_by_name(lender.name + ' 160x600').id.to_s+'/')

		end
		it "renders the :index view" do
			lender = FactoryGirl.create(:term_loan, partner: FactoryGirl.create(:partner), sniff_id: 2)
			banner = { name: lender.id, lender_link: 'http://test.com', lender_type: 'term'}
			expect { post :create, banner: banner }.to change(Banner, :count).by(1)
			#response.status.should be(302)
			#response.should redirect_to("/admin/banner/#{:id}")
		end

	end
end

