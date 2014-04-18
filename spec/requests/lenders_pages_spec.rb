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
    it { should have_link('Pre-Approved Lenders', href:"/why-use-the-payday-hound/") }
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}
    # lender in description
    it { should have_css("meta[name='description'][content='#{@lender.name} review. Compare rates, fees, licenses. Search for the lowest fees. Apply direct. Save money at The Payday Hound.']", visible: false) }      
    it { should have_selector('h1', text: "#{@lender.name}") }      
  end

  describe "Show Lender Pages" do
  	context "Term Lender" do
  		before {
  			@lender = FactoryGirl.create(:term_loan)
        FactoryGirl.create(:payday_loan, review_url:@lender.review_url)
  			visit lender_path(@lender.review_url, type:'term')
  		}

      it "should show term lenders details" do
        page.should have_selector('h1', text: @lender.name)
        page.should have_link('Apply Direct', href: "#{partner_path(@lender.partner_id)}/")
      end
    
      it_should_behave_like "all lender show pages"  		
  	end

    context "Payday Lender" do
      before {
        @lender = FactoryGirl.create(:payday_loan)
        FactoryGirl.create(:term_loan, review_url:@lender.review_url)
        visit lender_path(@lender.review_url, type:'payday')
      }

      it "should show term lenders details" do
        page.should have_selector('h1', text: @lender.name)
        page.should have_link('Apply Direct', href: "#{partner_path(@lender.partner_id)}/")
      end
    
      it_should_behave_like "all lender show pages"     
    end  	
 
    context "Payday and Term Lender with no params[:type]" do
      before {
        @lender = FactoryGirl.create(:term_loan)
        FactoryGirl.create(:payday_loan, review_url:@lender.review_url)
        visit lender_path(@lender.review_url)
        #puts page.body
      }

      it "should show term lender details" do
        page.should have_selector('h1', text: @lender.name)
        page.should have_link('Apply Direct', href: "#{partner_path(@lender.partner_id)}/")
      end
    
      it_should_behave_like "all lender show pages"     
    end  

    context "Payday with no params[:type]" do
      before {
        @lender = FactoryGirl.create(:payday_loan)
        visit lender_path(@lender.review_url)
        #puts page.body
      }

      it "should show lender details" do
        page.should have_selector('h1', text: @lender.name)
        page.should have_link('Apply Direct', href: "#{partner_path(@lender.partner_id)}/")
      end
    
      it_should_behave_like "all lender show pages"     
    end 

    context "Unpaid lender" do
      before {
        @lender = FactoryGirl.create(:payday_loan, paid: false)
        visit lender_path(@lender.review_url)
        #puts page.body
      }

      it "should show lender finder" do
        page.should have_selector('div', text: 'Finding a Loan Made Simple')
      end
    
      it_should_behave_like "all lender show pages"     
    end 


    context "Paid lender" do
      before {
        @lender = FactoryGirl.create(:payday_loan, paid: true)
        visit lender_path(@lender.review_url)
        #puts page.body
      }

      it "should not show lender finder" do
        page.should_not have_selector('div', text: 'Finding a Loan Made Simple')
      end
    
      it_should_behave_like "all lender show pages"     
    end 

  end


  after(:all){
    Sniff.destroy_all
  }  
    
end
