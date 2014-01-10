require 'spec_helper' 

describe "Keyword Model" do 
	it "has a valid factory" do
		FactoryGirl.create(:keyword).should be_valid
	end	
end