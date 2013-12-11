require 'spec_helper'

describe PaydayLoansController do
  before (:all){ 
    FactoryGirl.create(
      :keyword,
      word:      "payday loans",
      phrase:    "payday loans",
      slug:      "payday-loans",
      state_phrase: "compare payday loans",
      category:  "loans",
      article:   "I'm the article",
      parent_page: "payday loans",
    )
  }

	describe "GET #index"	do

		it "populates array of States" do
			state = FactoryGirl.create(:state)
			get :index
			assigns(:states).should eq([state])
		end	
		it "orders lender by rank" do
			2.times {FactoryGirl.create(:payday_loan)}
			state = FactoryGirl.create(:state)
			get :index
			assigns(:lenders).first.ranking.should be > assigns(:lenders).last.ranking
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

	after(:all){
		Keyword.destroy_all
		State.destroy_all
		PaydayLoan.destroy_all
	}

end