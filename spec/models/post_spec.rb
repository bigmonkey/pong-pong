require 'spec_helper'

describe Post do
	it "has a valid factory" do
		FactoryGirl.create(:post).should be_valid
	end	
	it "is invalid without a title" do
		FactoryGirl.build(:post, title:nil).should_not be_valid
	end 
	it "is invalid without a slug" do
		FactoryGirl.build(:post, slug:nil).should_not be_valid
	end 

	after(:all){
		Post.destroy_all
	}
end
