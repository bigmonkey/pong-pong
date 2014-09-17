require 'spec_helper'

describe "Partner Pages" do 

	subject { page }

	describe "Show" do

		context "Basic Partner Page" do
			before {
				FactoryGirl.create(:partner, lender_link: "http://lender-link.com")
				visit ("/partners/#{Partner.find_by_lender_link("http://lender-link.com").id.to_s}/")	

			}	

			it {should have_link('click here', href:"http://lender-link.com")}
		end

		context "Paid Partner" do
			before{
				partner = FactoryGirl.create(:partner)
	      # Create Sniff table
	      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
	      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
	      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
	 			# Create Paid Term Lender
	 			FactoryGirl.create(:term_loan, paid: true, partner_id: partner.id)
	 			visit ("/partners/#{partner.id}/")	
	 			#binding.pry
	 			#puts page.body
			}

		  #it "should have taboola pixel" do
		  #  page.should have_css("img[src*='taboola']")
			#end		

		  it "should have arcametric pixel" do
		    page.should have_css("img[src*='arcasync']")
			end	
			
		end

		context "Unpaid Partner" do
			before{
				partner = FactoryGirl.create(:partner)
	      # Create Sniff table
	      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
	      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
	      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
	 			# Create Paid Term Lender
	 			FactoryGirl.create(:term_loan, paid: false, partner_id: partner.id)
	 			visit ("/partners/#{partner.id}/")				
			}

		  it "should not have taboola pixel" do
		    page.should_not have_css("img[src*='taboola']")
			end		

		  it "should not have taboola pixel" do
		    page.should_not have_css("img[src*='arcasync']")
			end		

		end
	
	
	end


end