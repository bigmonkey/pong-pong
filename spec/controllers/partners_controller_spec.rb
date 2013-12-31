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

	describe "Save Tracking Variables" do
		it "sets token session variable" do
			get :show, id: FactoryGirl.create(:partner)
			session[:token].should_not be_nil
		end
		it "sets exit_page session variable" do
			get :show, id: FactoryGirl.create(:partner)
			session[:exit_page].should_not be_nil
		end
		it "saves time_on_site" do
			session["entry_time"]= 10.minutes.ago
			get :show, id: FactoryGirl.create(:partner)
			Applicant.find_by_token(session[:token]).time_on_site.should >600
		end
		it "saves referer uri components" do
			session[:referer_uri] = "http://some.domain.com/path?query=this"
			get :show, id: FactoryGirl.create(:partner)
			Applicant.find_by_token(session[:token]).host.should eq('some.domain.com')
			Applicant.find_by_token(session[:token]).path.should eq('/path')
			Applicant.find_by_token(session[:token]).path.should eq('query=this')
		end


		it "saves basic session variables to database" do
			# session_vars must match corresponding values in %w array below
			session_vars = %w[:referer_uri :src :exit_page :page_visits :device]
			%w[http://some.domain.com/path hippo /exit-page/path 5 mobile].each_with_index do |var, index|
				session[session_vars[index].parameterize.to_sym] = var
				get :show, id: FactoryGirl.create(:partner)
				Applicant.find_by_token(session[:token]).referer_uri.should eq(var)
			end
		end

	end

end