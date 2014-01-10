require 'spec_helper' 

describe "Payday Loans State Model" do 
	it "has a valid factory" do
		FactoryGirl.create(:payday_loans_state).should be_valid
	end	
end