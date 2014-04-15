require 'spec_helper' 

describe "Partner Model" do 
	it "has a valid factory" do
		FactoryGirl.create(:partner).should be_valid
	end	

	it "is invalide without a lender_link" do
		FactoryGirl.build(:partner, lender_link:nil).should_not be_valid
	end
end