require 'spec_helper' 

describe "State" do 
	it "has a valid factory" do
		FactoryGirl.create(:state).should be_valid
	end	
	it "saves lowecaser state_abbr as upcase" do
		lowerstate = FactoryGirl.create(:state, state_abbr: "tx")
		lowerstate.state_abbr.should eq("TX")
	end		
	it "has unique state" do
		FactoryGirl.create(:state, state: "Texas")
		FactoryGirl.build(:state, state: "Texas").should_not be_valid
	end
	it "has unique state_abbr" do
		FactoryGirl.create(:state, state_abbr: "TX")
		FactoryGirl.build(:state, state_abbr: "TX").should_not be_valid
	end			
end