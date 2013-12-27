require 'spec_helper'

describe "Borrower Pages" do
	subject { page }

	shared_examples_for "all pages" do
    # keyword in title
    it { should have_title("The Payday Hound") }
    # Lender Status
    it { should have_selector('h2', text:"Application System Status") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}
    # check for footer
    it { should have_link('About Us', href:"/infos/about/")}
  end

  describe "Borrower #New" do
  	before {
  		visit applicants_path
			select "Texas", from: "state"
			select "Checking", from: "bank_account_type"
			click_button "Find a Loan"  		
  	}
 

	  it_should_behave_like "all pages"
	end  
end



