require 'spec_helper' 

describe "States Term Loan Model" do 
	it "has a valid factory" do
		FactoryGirl.create(:states_term_loan).should be_valid
	end	
end