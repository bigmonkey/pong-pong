require 'spec_helper' 

describe "Applicant Model" do 
	it "has a valid factory" do
		FactoryGirl.create(:applicant).should be_valid
	end	
	it "generates a token" do
		FactoryGirl.create(:applicant).token.should_not be_nil 
	end		
	
after(:all){
	Applicant.destroy_all
}
end