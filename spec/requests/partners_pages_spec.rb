require 'spec_helper'

describe "Partner Pages" do 

	subject { page }

	describe "Show" do
		before {
			FactoryGirl.create(:partner, lender_link: "http://lender-link.com")
			visit ("/partners/#{Partner.find_by_lender_link("http://lender-link.com").id.to_s}")

		}

		it {should have_link('click here', href:"http://lender-link.com")}
		
	end


end