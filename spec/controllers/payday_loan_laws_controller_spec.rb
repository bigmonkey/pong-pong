require 'spec_helper'

describe PaydayLoanLawsController do
	describe "GET #index"	do
		it "populates array of States" do
			state = FactoryGirl.create(:state)
			get :index
			assigns(:states).should eq([state])
		end	
		it "renders the :index view" do
			get :index
			response.should render_template :index
		end	
	end
	
	describe "GET #show" do
		it "assigns requested state to @state" do
			state = FactoryGirl.create(:state)
			get :show, id: state
			assigns(:state).should eq(state)
		end	

		it "renders the #show view" do
			get :show, id: FactoryGirl.create(:state)
			response.should render_template :show
		end
	end
end