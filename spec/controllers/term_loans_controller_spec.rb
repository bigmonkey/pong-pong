require 'spec_helper'

describe TermLoansController do
  before { 
    FactoryGirl.create(
      :keyword,
      word:      "installment loans",
      phrase:    "installment loans",
      state_phrase: "compare installment loans",
      category:  "loans",
      article:   "I'm the article",
      parent_page: "installment loans",
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
		it "renders the :index view" do
			get :index
			response.should render_template :index
		end	
		it "orders lenders by rank" do
			FactoryGirl.create(:term_loan, ranking: 5)
			FactoryGirl.create(:term_loan, ranking: 1)
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

		it "shows a table with the correct states" do
			2.times { FactoryGirl.create(:state) }
			2.times { FactoryGirl.create(:term_loan) }
			FactoryGirl.create(:states_term_loan, term_loan_id: TermLoan.first.id, state_id: State.first.id)
			get :show, id: State.first.state_abbr
			assigns(:lenders).first.should eq(TermLoan.first)
		end

		it "shows a table excluding other states" do
			2.times { FactoryGirl.create(:state) }
			2.times { FactoryGirl.create(:term_loan) }
			FactoryGirl.create(:states_term_loan, term_loan_id: TermLoan.first.id, state_id: State.first.id)
			get :show, id: State.first.state_abbr
			assigns(:lenders).count.should eq(1)
		end

		it "redirects to /installment-loans/ if state params is invalid" do
			state = FactoryGirl.create(:state) 
			get :show, id: "xx"
			response.should redirect_to '/installment-loans/'
		end

		it "assigns sniff_score to 3 if sniff_score params is blank" do
			state = FactoryGirl.create(:state) 
			get :show, id: state.state_abbr, sniff_score: ""
			assigns(:criteria).sniff_id.should eq(Sniff.find_by_sniff_score(3).id)
		end

		it "assigns sniff_score to 2 if sniff_score params is 2" do
			state = FactoryGirl.create(:state) 
			get :show, id: state.state_abbr, sniff_score: 2
			assigns(:criteria).sniff_id.should eq(Sniff.find_by_sniff_score(2).id)
		end

		it "assigns ranking to 1 if ranking is blank" do
			state = FactoryGirl.create(:state) 
			get :show, id: state.state_abbr, ranking: ""
			assigns(:criteria).ranking.should eq(1)
		end

		it "assigns ranking to 2 if ranking params is 2" do
			state = FactoryGirl.create(:state) 
			get :show, id: state.state_abbr, ranking: 2
			assigns(:criteria).ranking.should eq(2)
		end

		it "selects paid lenders for that state" do
			FactoryGirl.create(:term_loan) 
			FactoryGirl.create(:term_loan, paid:true) 
			state = FactoryGirl.create(:state)
			paid_state_lenders = 2
			paid_state_lenders.times do 
				state_lender = FactoryGirl.create(:term_loan, paid: true)
				FactoryGirl.create(:states_term_loan, term_loan_id: state_lender.id, state_id: state.id)
			end
			get :show, id: state.state_abbr.downcase
			assigns(:paid_lenders).count.should eq(paid_state_lenders)
		end

		it "selects paid lenders 160x600 banners for a state" do
			state = FactoryGirl.create(:state)
			term_banner = FactoryGirl.create(:term_loan_banner, rotation_rank: 5)
			FactoryGirl.create(:states_term_loan, term_loan_id: term_banner.bannerable.id, state_id: state.id)
			payday_banner = FactoryGirl.create(:payday_loan_banner, rotation_rank: 5)
			FactoryGirl.create(:payday_loans_state, payday_loan_id: payday_banner.bannerable.id, state_id: state.id)
			advertiser_banner = FactoryGirl.create(:advertiser_loan_banner, rotation_rank: 5)
			FactoryGirl.create(:advertiser_loans_state, advertiser_loan_id: advertiser_banner.bannerable.id, state_id: state.id)
			get :show, id: state.state_abbr.downcase
			assigns(:paid_banner).should_not be_nil
		end

		it "removes banners with 0 rotation_rank from banner queue" do
			state = FactoryGirl.create(:state)
			term_banner = FactoryGirl.create(:term_loan_banner, rotation_rank: 5)
			FactoryGirl.create(:states_term_loan, term_loan_id: term_banner.bannerable.id, state_id: state.id)
			payday_banner = FactoryGirl.create(:payday_loan_banner, rotation_rank: 0)
			FactoryGirl.create(:payday_loans_state, payday_loan_id: payday_banner.bannerable.id, state_id: state.id)
			advertiser_banner = FactoryGirl.create(:advertiser_loan_banner, rotation_rank: 0)
			FactoryGirl.create(:advertiser_loans_state, advertiser_loan_id: advertiser_banner.bannerable.id, state_id: state.id)
			get :show, id: state.state_abbr.downcase
			assigns(:paid_banner).should eq(term_banner)
		end		

		it "does not select a banner if no lenders operate in a state" do
			state = FactoryGirl.create(:state)
			other_state = FactoryGirl.create(:state)
			term_banner = FactoryGirl.create(:term_loan_banner, rotation_rank: 5)
			FactoryGirl.create(:states_term_loan, term_loan_id: term_banner.bannerable.id, state_id: state.id)
			payday_banner = FactoryGirl.create(:payday_loan_banner, rotation_rank: 5)
			FactoryGirl.create(:payday_loans_state, payday_loan_id: payday_banner.bannerable.id, state_id: state.id)
			advertiser_banner = FactoryGirl.create(:advertiser_loan_banner, rotation_rank: 5)
			FactoryGirl.create(:advertiser_loans_state, advertiser_loan_id: advertiser_banner.bannerable.id, state_id: state.id)
			get :show, id: other_state.state_abbr.downcase
			assigns(:paid_banner).should eq(nil)
		end		
	end

	# "all controlers that set tracking" is in spec/support/shared_controller_tests
  it_should_behave_like "all controllers that set tracking"

end