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

  #it_should_behave_like "all controllers that set tracking"
	describe "Tracking Variables" do
		context "Visitor comes from ad partner" do
			it "sets ad campaign stats on first visit" do
				get :index, src: 'ad partner', camp: 'campaign'
				session[:src].should eq('ad partner')
				session[:camp].should eq('campaign')
			end		
			it "does not reset campaign stats as user browses pages" do
				get :index, src: 'ad partner', camp: 'campaign'
				get :index
				session[:src].should eq('ad partner')
				session[:camp].should eq('campaign')
			end
		end

		context "Visitor does not come from ad partner" do
			it "does not set ad campaign stats" do
				get :index
				session[:src].should be_nil
				session[:camp].should be_nil
			end		
			it "does not reset campaign stats as user browses pages" do
				get :index
				get :index
				session[:src].should be_nil
				session[:camp].should be_nil
			end
		end
		
		context "Vistor lands on site" do
			it "sets HTTP_REFERER session variable on first visit" do
				request.env["HTTP_REFERER"] = 'http://test.domain.com'
				get :index
				session[:referer_uri].should eq('http://test.domain.com')
			end	
			it "does not set HTTP_REFERER session variable as user browses" do
				request.env["HTTP_REFERER"] = 'http://test.domain.com'
				get :index
				get :index
				session[:referer_uri].should eq('http://test.domain.com')
			end	
		end
	end

end