require 'spec_helper'

describe "Partner Pages" do 

	subject { page }

	describe "Show" do
		before {
			FactoryGirl.create(:partner, id: 1, lender_link: "http://lender-link.com")
			visit ("/partners/#{Partner.find(1).id}")
		}
		
		it {should have_link('click here', href:"http://lender-link.com")}
		
	end


end