require 'spec_helper'

describe PostsTopic do
	it "has a valid factory" do
		FactoryGirl.create(:posts_topic).should be_valid
	end	
end
