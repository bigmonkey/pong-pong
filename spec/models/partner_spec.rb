require 'spec_helper' 

describe "Partner Model" do 
	it "has a valid factory" do
		FactoryGirl.create(:partner).should be_valid
	end	
end