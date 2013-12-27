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
      # Create Sniff table
      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad")     
  }

	describe "GET #index"	do

		it "populates array of States" do
			state = FactoryGirl.create(:state)
			get :index
			assigns(:states).should eq([state])
		end	
		it "orders lender by rank" do
			FactoryGirl.create(:payday_loan, ranking: 5)
			FactoryGirl.create(:payday_loan, ranking: 4)
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
		Sniff.destroy_all
	}

end