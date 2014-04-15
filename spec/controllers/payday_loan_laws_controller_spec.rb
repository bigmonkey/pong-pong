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
			get :show, id: state.state_abbr
			assigns(:state).should eq(state)
		end	

		it "renders the #show view" do
			state = FactoryGirl.create(:state)
			get :show, id: state.state_abbr
			response.should render_template :show
		end
	end

	# "all controlers that set tracking" is in spec/support/shared_controller_tests
  it_should_behave_like "all controllers that set tracking"	
end