require 'spec_helper'

describe "Article Model" do 

	it "has a valid factory" do
		FactoryGirl.create(:article).should be_valid
	end	
	it "is invalid without a title" do
		FactoryGirl.build(:article, title:nil).should_not be_valid
	end 


	after(:all){
		Article.destroy_all
	}
end