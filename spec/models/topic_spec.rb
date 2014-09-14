require 'spec_helper'

describe Topic do
  
  it "has a valid term factory" do
		FactoryGirl.create(:topic).should be_valid
	end		
  
  it "is invalide without a topic" do
  	FactoryGirl.build(:topic, topic:nil).should_not be_valid
  end

  after(:all) {
   	Topic.destroy_all
  }
end