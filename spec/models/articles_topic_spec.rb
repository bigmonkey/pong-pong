require 'spec_helper'

describe ArticlesTopic do
	it "has a valid factory" do
		FactoryGirl.create(:articles_topic).should be_valid
	end	
end
