require 'spec_helper'

describe "Installment Loan Pages" do
	subject { page }

  shared_examples_for "all installment loan pages" do
    # based title tag
    it { should have_title 'The Payday Hound' }   
    # sidebar
    it { should have_link('Why Use Us', href:"/infos/about/") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}
  end

  shared_examples_for "all index installment loan pages" do

      it "should have the state selector linking to 50 states" do       
        State.all.each do |s|
          page.should have_link(s.state, href:"/#{@keyword.slug}/#{s.state_abbr.downcase}/") 
        end  
      end  

      it "should have table of lenders" do
        TermLoan.all.each do |t|
          page.should have_content("Company Name")
          page.should have_selector('div', text: t.first_comment)
          page.should have_link("see review", href: "/learn/#{t.review_url}/" )      
          page.should have_link("Apply Direct", href: "#{partner_path(t.partner_id)}/" )
        end  
      end


  end

  describe "Installment Loan Pages" do
    
    before(:all) { 
      # Create State table
      50.times { FactoryGirl.create(:state) }
      # Create Sniff table
      FactoryGirl.create(:sniff, id: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, id: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, id: 3, sniff_desc: "Poor") 
      # Create Terms table
      15.times { FactoryGirl.create(:term_loan) }
    } 

    describe "Installment Loan Main Page" do
      before { 
        @keyword = FactoryGirl.create(
          :keyword,
          word:      "installment loans",
          phrase:    "installment loans",
          slug:      "installment-loans",
          state_phrase: "compare installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "installment loans",
          controller:  "term"        
        )
        visit term_loans_path 
        #puts page.body
      }  

      it { should have_selector('h1', text: 'Installment Loans') }
      it { should have_content('Compare Installment Loans') }
      it_should_behave_like "all index installment loan pages"
      it_should_behave_like "all installment loan pages"
    end  
    # Installment Loan Main Page

    after(:all){
      Sniff.destroy_all
      State.destroy_all
      TermLoan.destroy_all
    }
  end

end

#RAILS_ENV=test rake db:drop db:create db:migrate
#bundle exec rspec spec/requests/term_loans_spec.rb:9
