require 'spec_helper'

describe "Payday Loan Law Pages" do 
	subject { page }

	shared_examples_for "all payday loan law pages" do  
    # keyword in title
    it { should have_title("Payday Loan Laws") }
    # sidebar
    it { should have_link('Find Pre-Approved Lenders Instantly', href:"/why-use-the-payday-hound/") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}		
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}
	end

	describe "Index Page" do  
		before(:all){
      # Create State table
      10.times { FactoryGirl.create(:state) }
		}

		before { 
			visit payday_loan_laws_path
			#puts page.body

		}

    it "should have the state selector linking to 50 states" do  
      State.all.each do |s|
        page.should have_link(s.state, href:"/payday-loan-laws/#{s.state_abbr.downcase}/") 
      end  
    end  

		it { should have_selector('h1', 'Payday Loan State Laws') }
		it_should_behave_like "all payday loan law pages"
	
		after(:all) {
			State.destroy_all
		}
	end

	describe "State Page" do 
		before(:all){
			FactoryGirl.create(
				:state,
				id: 1,
				state_abbr: "TX",
				state: "Texas")
			FactoryGirl.create(
				:payday_loan_law_detail,
				id: 1,
				state_abbr: "TX",
				ncsl_citation: "TX statute blah")
			FactoryGirl.create(
				:payday_loan_law,
				id: 1,
				state_abbr: "TX",
				name: "Texas",
				regulator: "Texas regulator",
				regulator_site: "texas-regulator",
				legal_status: "Legal")
			@state = State.find_by_state_abbr("TX")
			@paydaylawstate = @state.payday_loan_law
			@paydaylawstatedetails = @state.payday_loan_law_detail
		}

		context "existing state" do 

			before { visit "/payday-loan-laws/TX" }	

			it { should have_selector('h1', text:"#{@state.state} Payday Loan Laws") }
			it { should have_selector('h2', text: 'Regulator Details') }
			it { should have_content("#{@paydaylawstate.legal_status.downcase}") }
			it { should have_link("#{@paydaylawstate.regulator}", @paydaylawstate.regulator_site)}
		
		end
		
		context "non-existing state" do 

			before { visit "/payday-loan-laws/fr" }

			it { should have_selector('h1', text: 'Payday Loan State Laws')}
			it { should_not have_selector('h1', text: "#{@state.state} Payday Loan Laws") }

		end

		after(:all) {
			State.destroy_all
			PaydayLoanLawDetail.destroy_all
			PaydayLoanLaw.destroy_all
		}

	end	

end
