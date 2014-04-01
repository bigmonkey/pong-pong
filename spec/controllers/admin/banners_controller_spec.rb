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
		# Note: params[:banner][:name] is actually <lender>.id
		it "redirects to the :show view" do
			lender = FactoryGirl.create(:term_loan, partner: FactoryGirl.create(:partner), sniff_id: 2)
			banner = { name: lender.id, lender_link: 'http://test.com', lender_type: 'term'}
			post :create, banner: banner			
			#response.should redirect_to('/admin/banners/' + Banner.find_by_name(lender.name + ' 160x600').id.to_s+'/')
			response.should redirect_to('/admin/banners/' + assigns(:banner).id.to_s+'/')
		end

		it "saves a new banner and partner" do
			lender = FactoryGirl.create(:term_loan, partner: FactoryGirl.create(:partner), sniff_id: 2)
			banner = { name: lender.id, lender_link: 'http://test.com', lender_type: 'term'}
			expect { post :create, banner: banner }.to change(Banner, :count).by(1)
			expect { post :create, banner: banner }.to change(Partner, :count).by(1)
		end

		it "creates a banner associated to a term loan" do
			lender = FactoryGirl.create(:term_loan, partner: FactoryGirl.create(:partner), sniff_id: 2)
			banner = { name: lender.id, lender_link: 'http://test.com', lender_type: 'term'}
			post :create, banner: banner
			assigns(:banner).bannerable.id.should eq(lender.id)
		end

		it "creates a banner associated by a term loan" do
			lender = FactoryGirl.create(:term_loan, partner: FactoryGirl.create(:partner), sniff_id: 2)
			banner = { name: lender.id, lender_link: 'http://test.com', lender_type: 'term'}
			post :create, banner: banner
			TermLoan.find(lender.id).banners.find(assigns(:banner)).id.should eq(assigns(:banner).id)
		end		

		it "creates a banner associated to a partner" do
			lender = FactoryGirl.create(:term_loan, partner: FactoryGirl.create(:partner), sniff_id: 2)
			lender_link = 'http://test.com'
			banner = { name: lender.id, lender_link: lender_link, lender_type: 'term'}
			post :create, banner: banner
			assigns(:banner).partner_id.should eq(Partner.find_by_lender_link('http://test.com').id)
		end
	end
end

