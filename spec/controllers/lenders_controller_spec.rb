require 'spec_helper'

describe LendersController do
  before(:all){    # Create Sniff table
      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
  }

	describe "GET #index"	do
		it "redirects to home" do
			get :index
			response.should redirect_to root_path
		end
	end
	
	describe "GET #show" do
		it "assigns a lender if one exits" do
			lender = FactoryGirl.create(:payday_loan)
			get :show, id: lender.review_url
			assigns(:lender).should eq(lender)
		end	

		it "assigns a lender to nil if none exits" do
			get :show, id: ""
			assigns(:lender).should be_nil
		end	

		it "assigns payday lender for type=payday" do
			lender = FactoryGirl.create(:payday_loan)
			get :show, id: lender.review_url, type: 'payday'
			assigns(:lender).should eq(lender)
		end

		it "assigns term data for type = term lender with payday and term" do
			payday_lender = FactoryGirl.create(:payday_loan, review_url: "this_lender")
			term_lender = FactoryGirl.create(:term_loan, review_url: "this_lender")
			get :show, id: term_lender.review_url, type: 'term'
			assigns(:lender).should eq(term_lender)
		end

		it "assigns term lender for type=term" do
			lender = FactoryGirl.create(:term_loan)
			get :show, id: lender.review_url, type: 'term'
			assigns(:lender).should eq(lender)
		end

		it "assigns payday data for type = payday lender with payday and term" do
			payday_lender = FactoryGirl.create(:payday_loan, review_url: "this_lender")
			term_lender = FactoryGirl.create(:term_loan, review_url: "this_lender")
			get :show, id: payday_lender.review_url, type: 'payday'
			assigns(:lender).should eq(payday_lender)
		end

		describe "lender exists but no type is passed" do
			context "lender is term lender" do
				it "assigns the term lender" do
					term_lender = FactoryGirl.create(:term_loan)
					get :show, id: term_lender.review_url
					assigns(:lender).should eq(term_lender)
				end
			end
			context "lender is payday lender" do
				it "assigns payday lender" do
					payday_lender = FactoryGirl.create(:payday_loan)
					get :show, id: payday_lender.review_url
					assigns(:lender).should eq(payday_lender)
				end
			end
		end

		describe "set loan finder path for unpaid lenders`" do
			context "term lender" do
				it "sets path to installment loans" do
					term_lender = FactoryGirl.create(:term_loan, paid: false)
					get :show, id: term_lender.review_url
					assigns(:path).should eq('installment-loans')
				end
			end
			context "payday lender" do
				it "sets path to payday loans" do
					payday_lender = FactoryGirl.create(:payday_loan, paid: false)
					get :show, id: payday_lender.review_url
					assigns(:path).should eq('payday-loans')
				end
			end
		end



		it "renders the #show view" do
			get :show, id:''
			response.should render_template :show
		end

	end

	# "all controlers that set tracking" is in spec/support/shared_controller_tests
  it_should_behave_like "all controllers that set tracking"

  after(:all){
  	Sniff.destroy_all
  }
end