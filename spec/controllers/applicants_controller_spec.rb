require 'spec_helper'

describe ApplicantsController do
	describe "GET #index"	do

		it "assign requested loan amount to 300" do
			get :index
			assigns(:requested_amount).should eq(300)
		end	
		it "renders the :index view" do
			get :index
			response.should render_template :index
		end	
	end
	

end
