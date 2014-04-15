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
		# Assumes three models TermLoan, PaydayLoan, AdvertiserLoan
		shared_examples "a banner POST #create" do |lender_type,|
			it "redirects to the #{lender_type.titleize + " Loan"} :show view" do
				lender = FactoryGirl.create((lender_type+'_loan').to_sym, sniff_id: 2)
				banner = { name: lender.id, lender_link: 'http://test.com', lender_type: lender_type}
				post :create, banner: banner			
				#response.should redirect_to('/admin/banners/' + Banner.find_by_name(lender.name + ' 160x600').id.to_s+'/')
				response.should redirect_to admin_banner_url(assigns(:banner).id)
			end
			it "saves a new #{lender_type.titleize + " Loan"} banner and partner" do
				lender = FactoryGirl.create((lender_type+'_loan').to_sym, sniff_id: 2)
				banner = { name: lender.id, lender_link: 'http://test.com', lender_type: lender_type}
				expect { post :create, banner: banner }.to change(Banner, :count).by(1)
				expect { post :create, banner: banner }.to change(Partner, :count).by(1)
			end	

			it "creates a banner that belongs_to a #{lender_type.titleize + " Loan"}" do
				lender = FactoryGirl.create((lender_type+'_loan').to_sym, sniff_id: 2)
				banner = { name: lender.id, lender_link: 'http://test.com', lender_type: lender_type}
				post :create, banner: banner
				assigns(:banner).bannerable.id.should eq(lender.id)
			end	

			it "creates a banner who is has_many'd by a #{lender_type.titleize + " Loan"}" do
				lender = FactoryGirl.create((lender_type+'_loan').to_sym, sniff_id: 2)
				banner = { name: lender.id, lender_link: 'http://test.com', lender_type: lender_type}
				post :create, banner: banner
				(lender_type.titleize+'_loan').camelize.constantize.find(lender.id).banners.find(assigns(:banner)).id.should eq(assigns(:banner).id)
			end			

			it "creates a #{lender_type.titleize + " Loan"} banner associated to a partner" do
				lender = FactoryGirl.create((lender_type+'_loan').to_sym, sniff_id: 2)
				lender_link = 'http://test.com'
				banner = { name: lender.id, lender_link: lender_link, lender_type: lender_type}
				post :create, banner: banner
				assigns(:banner).partner_id.should eq(Partner.find_by_lender_link('http://test.com').id)
			end
		end

		it_should_behave_like "a banner POST #create", 'term'
		it_should_behave_like "a banner POST #create", 'payday'
		it_should_behave_like "a banner POST #create", 'advertiser'

	end

	describe "PATCH #update" do
		# Assumes three models TermLoan, PaydayLoan, AdvertiserLoan
		shared_examples "a banner PATCH #update" do |lender_type,|
			it "redirects to the #{lender_type.titleize + " Loan"} :show view" do
				banner = FactoryGirl.create((lender_type+'_loan_banner').to_sym)
				partner = banner.partner
				updates = { name: banner.name, rotation_rank: banner.rotation_rank, lender_link: partner.lender_link}
				patch :update, banner: updates, id: banner.id			
				response.should redirect_to admin_banner_url(banner.id)
			end
			it "updates #{lender_type.titleize + " Loan"} banner details" do
				banner = FactoryGirl.create((lender_type+'_loan_banner').to_sym)
				banner.name = "new name"
				banner.rotation_rank = 4
				updates = { name: banner.name, lender_link: 'http://new.com',rotation_rank: banner.rotation_rank}
				patch :update, banner: updates, id: banner.id			
				banner.reload
				banner.name.should eq("new name")
				banner.rotation_rank.should eq(4)
			end

			it "updates #{lender_type.titleize + " Loan"} banner's partner details" do
				banner = FactoryGirl.create((lender_type+'_loan_banner').to_sym)
				partner = banner.partner
				partner.lender_link = "http://new.com"
				partner.lender_tail = "?tail="
				updates = { lender_link: partner.lender_link, lender_tail: partner.lender_tail}
				patch :update, banner: updates, id: banner.id			
				banner.reload
				banner.partner.lender_link.should eq('http://new.com')
				banner.partner.lender_tail.should eq('?tail=')
			end

			it "redirects #{lender_type.titleize + " Loan"} banner's w/o lender links to #show" do
				banner = FactoryGirl.create((lender_type+'_loan_banner').to_sym)
				updates = { name: "new name"}
				patch :update, banner: updates, id: banner.id			
				response.should redirect_to admin_banner_url(banner.id)
			end
		end

		it_should_behave_like "a banner PATCH #update", 'term'
		it_should_behave_like "a banner PATCH #update", 'payday'
		it_should_behave_like "a banner PATCH #update", 'advertiser'

	end

	describe " DELETE #destroy" do
		# Assumes three models TermLoan, PaydayLoan, AdvertiserLoan
		shared_examples "a banner DELETE #destroy" do |lender_type,|
			it "redirects to the #{lender_type.titleize + " Loan"} :index view" do
				banner = FactoryGirl.create((lender_type+'_loan_banner').to_sym)
				delete :destroy, id: banner			
				response.should redirect_to admin_banners_url
			end
			it "deletes #{lender_type.titleize + " Loan"} banner" do
				banner = FactoryGirl.create((lender_type+'_loan_banner').to_sym)
				expect { delete :destroy, id: banner }.to change(Banner, :count).by(-1)
			end
			it "deletes #{lender_type.titleize + " Loan"} banner's Partner" do
				banner = FactoryGirl.create((lender_type+'_loan_banner').to_sym)
				expect { delete :destroy, id: banner }.to change(Partner, :count).by(-1)
			end

		end

		it_should_behave_like "a banner DELETE #destroy", 'term'
		it_should_behave_like "a banner DELETE #destroy", 'payday'
		it_should_behave_like "a banner DELETE #destroy", 'advertiser'

	end			
end

