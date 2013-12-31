require 'spec_helper'

describe PartnersController do


	describe "GET #show" do
		context "Valid Partner ID" do
			it "renders the :show view" do
				# HTTP_REFERER is used in partners#show 
				request.env["HTTP_REFERER"] = 'http://www.thepaydayhound.com/lastpage?var=hippo' 
				# this is used in application#save_tracking
				session[:entry_time]= 10.minutes.ago
				get :show, id: FactoryGirl.create(:partner)
				response.should render_template :show
			end

			describe "Lender URL" do
				before(:each) { 
					# HTTP_REFERER is used in partners#show 
					request.env["HTTP_REFERER"] = 'http://www.thepaydayhound.com/lastpage?var=hippo' 
					# this is used in application#save_tracking
					session[:referer_uri] = "http://some.domain.com/path?query=this"					
					session[:entry_time]= 10.minutes.ago
				}
				it "is assigned if there is no affiliate sid" do
					get :show, id: FactoryGirl.create(:partner, lender_link: "http://lender-link.com")
					assigns(:lender_url).should eq('http://lender-link.com')
				end		
				it "is assigned if there is an affilaite sid" do
					get :show, id: FactoryGirl.create(:partner, lender_link: "http://lender-link.com", lender_tail: "?tail=")
					assigns(:lender_url).should eq('http://lender-link.com?tail=' + session[:token])
				end
			end	

			describe "Save Tracking Variables" do
				context "All Visitors" do
					before(:each) { 
						# HTTP_REFERER is used in partners#show 
						request.env["HTTP_REFERER"] = 'http://www.thepaydayhound.com/lastpage?var=hippo' 
						# used in application#save_tracking
						session[:entry_time]= 10.minutes.ago
					}
					it "sets token session variable" do
						get :show, id: FactoryGirl.create(:partner)
						session[:token].should_not be_nil
					end
					it "sets exit_page session variable" do
						get :show, id: FactoryGirl.create(:partner)
						# session[:exit_page] is based on HTTP_REFERER set in before(:each)
						session[:exit_page].should eq('/lastpage?var=hippo')
					end
					it "saves time_on_site" do
						get :show, id: FactoryGirl.create(:partner)
						Applicant.find_by_token(session[:token]).time_on_site[3..4].should eq('10')
					end
				
				end

				context "Visitor is Refered" do
					before(:each) { 
						# HTTP_REFERER is used in partners#show 
						request.env["HTTP_REFERER"] = 'http://www.thepaydayhound.com/lastpage?var=hippo' 
						# used in application#save_tracking
						session[:referer_uri] = "http://some.domain.com/path?query=this"					
						session[:entry_time]= 10.minutes.ago
					}
					it "saves referer uri components" do	
						get :show, id: FactoryGirl.create(:partner)
						Applicant.find_by_token(session[:token]).referer_host.should eq('some.domain.com')
						Applicant.find_by_token(session[:token]).referer_path.should eq('/path')
						Applicant.find_by_token(session[:token]).referer_query.should eq('query=this')
					end	
					it "saves basic session variables to database" do
						# session_vars must match corresponding values in %w array below
						session_vars = %w[referer_uri src page_views device]
						["http://some.domain.com/path", "hippo", 5, "mobile"].each_with_index do |var, index|
							session[session_vars[index].parameterize.to_sym] = var
							get :show, id: FactoryGirl.create(:partner)
							Applicant.find_by_token(session[:token]).send(session_vars[index]).should eq(var)
						end
					end
				end	
				context "Visiter is Direct" do
					before(:each) { 
						# HTTP_REFERER is used in partners#show 
						request.env["HTTP_REFERER"] = 'http://www.thepaydayhound.com/lastpage?var=hippo' 
						# used in application#save_tracking
						session[:entry_time]= 10.minutes.ago
					}
					it "saves referer uri components" do	
						get :show, id: FactoryGirl.create(:partner)
						Applicant.find_by_token(session[:token]).referer_host.should eq(nil)
						Applicant.find_by_token(session[:token]).referer_path.should eq(nil)
						Applicant.find_by_token(session[:token]).referer_query.should eq(nil)
					end	
					it "saves basic session variables to database" do
						# session_vars must match corresponding values in %w array below
						session_vars = %w[referer_uri src page_views device]
						["", "hippo", 5, "mobile"].each_with_index do |var, index|
							session[session_vars[index].parameterize.to_sym] = var
							get :show, id: FactoryGirl.create(:partner)
							Applicant.find_by_token(session[:token]).send(session_vars[index]).should eq(var)
						end
					end
				end	

			end

		end

		context "Invalid Partner ID" do
			it "redirects to home if no ID is preset" do
				get :show, id: ""
				response.should redirect_to("/")
			end
			it "redirect to home if no lender matches ID" do
				# HTTP_REFERER is used in partners#show 
				request.env["HTTP_REFERER"] = 'http://www.thepaydayhound.com/lastpage?var=hippo' 
				# this is used in application#save_tracking
				session[:referer_uri] = "http://some.domain.com/path?query=this"					
				session[:entry_time]= 10.minutes.ago
				get :show, id: (Partner.all.count + 1)
				response.should redirect_to("/")
			end
		end
	end
end