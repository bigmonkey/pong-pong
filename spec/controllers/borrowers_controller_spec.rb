require 'spec_helper'

describe BorrowersController do
	describe "POST #new"	do
		describe "Bad Applicants" do
			context "Blanks" do
				it "redirects blank active_military" do
					post :new, FactoryGirl.attributes_for(:applicant, active_military: "")
					response.should redirect_to applicants_path
				end
				it "redirects blank bank_account_type" do
					post :new, FactoryGirl.attributes_for(:applicant, bank_account_type: "")
					response.should redirect_to applicants_path
				end
				it "redirects blank state" do
					post :new, FactoryGirl.attributes_for(:applicant, state: "")
					response.should redirect_to applicants_path
				end
				it "redirects blank reqested_amount" do
					post :new, FactoryGirl.attributes_for(:applicant, requested_amount: "")
					response.should redirect_to applicants_path
				end	
				it "does not save applicant data" do
					expect {post :new, FactoryGirl.attributes_for(:applicant, requested_amount: "")}.to change(Applicant, :count).by(0)	
				end
			end
			context "Unacceptable Underwriting" do
				it "redirects military members" do
					post :new, FactoryGirl.attributes_for(:applicant, active_military: "true")
					response.should redirect_to("http://usmilitary.about.com/od/millegislation/a/paydayloans.htm")
				end	
				it "redirect NONE bank_account_type" do
					post :new, FactoryGirl.attributes_for(:applicant, bank_account_type: "NONE")
					response.should redirect_to("http://usmilitary.about.com/od/millegislation/a/paydayloans.htm")
				end	
				it "redirect under eighteen" do
					post :new, FactoryGirl.attributes_for(:applicant, eighteen: "false")
					response.should redirect_to("http://usmilitary.about.com/od/millegislation/a/paydayloans.htm")
				end
				it "redirects GA VA WV AR NY residents" do
					["GA","VA","WV","AR","NY"].each do |s|
						post :new, FactoryGirl.attributes_for(:applicant, state: s)
						response.should redirect_to("/payday-loans/#{s}")
					end
				end
			end
		end
		describe "Good Applicants" do
			it "renders the :new view" do
				post :new, FactoryGirl.attributes_for(:applicant)
				response.should render_template :new
			end		
			it "saves applicant data" do	
				expect { post :new, FactoryGirl.attributes_for(:applicant) }.to change(Applicant, :count).by(1)
			end
		end
	end
	after(:all) {Applicant.destroy_all}
end