require 'spec_helper' 

describe "Advertiser Loans State Model" do 
	it "has a valid factory" do
		FactoryGirl.create(:advertiser_loans_state).should be_valid
	end	
end
