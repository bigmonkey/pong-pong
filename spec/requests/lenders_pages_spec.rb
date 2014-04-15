require 'spec_helper'

describe "Lender Pages" do

	subject { page }

  before (:all){ 
    # Create Sniff table
    FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
    FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
    FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
  } 

  shared_examples_for "all lender show pages" do
    it { should have_title("#{@lender.name}") }
    # sidebar
    it { should have_link('Find Pre-Approved Lenders Instantly', href:"/why-use-the-payday-hound/") }
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}
    # lender in description
    it { should have_css("meta[name='description'][content='#{@lender.name} review. Compare rates, fees, licenses. Search for the lowest fees. Apply direct. Save money at The Payday Hound.']", visible: false) }      
    it { should have_selector('h1', text: "#{@lender.name}") }      
  end

  describe "Show Lender Pages" do
  	context "Term Lender" do
  		before {
  			@lender = FactoryGirl.create(:term_loan,

  				)
  			visit lender_path(@lender.review_url)
  		}

      it_should_behave_like "all lender show pages"  		
  	end
  	
  end


  after(:all){
    Sniff.destroy_all
  }  
    
end
