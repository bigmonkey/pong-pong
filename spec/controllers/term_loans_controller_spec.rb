require 'spec_helper'

describe TermLoansController do
  before(:all) { 
    FactoryGirl.create(
      :keyword,
      word:      "installment loans",
      phrase:    "installment loans",
      slug:      "installment-loans",
      state_phrase: "compare installment loans",
      category:  "loans",
      article:   "I'm the article",
      parent_page: "installment loans",
    )
  }

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
		it "orders lenders by rank" do
			2.times {FactoryGirl.create(:term_loan)}
			state = FactoryGirl.create(:state)
			get :index
			assigns(:lenders).first.ranking.should be > assigns(:lenders).last.ranking
		end
		it "orders lenders by cost within rank" do
			2.times {FactoryGirl.create(:term_loan, ranking:3)}
			state = FactoryGirl.create(:state)
			get :index
			assigns(:lenders).first.cost.should be < assigns(:lenders).last.cost
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
		TermLoan.destroy_all
	}

end