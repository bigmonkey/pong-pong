require 'spec_helper'

describe "Installment Loan Pages" do
	subject { page }

  shared_examples_for "all installment loan pages" do
    # keyword in title
    it { should have_title("#{@keyword.titleize}") }
    # sidebar
    it { should have_link('Why Use Us', href:"/infos/about/") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}
    # check for footer
    it { should have_link('About Us', href:"/infos/about/")}
  end

  shared_examples_for "all index installment loan pages" do
      # keyword in description
      it { should have_css("meta[name='description'][content='Compare #{@keyword}. Search for the lowest fees. Apply direct. Get the best rates at The Payday Hound.']", visible: false) }
      it "should have the state selector linking to 50 states" do  
        State.all.each do |s|
          page.should have_link(s.state, href:"/#{@keyword.gsub(' ','-')}/#{s.state_abbr.downcase}/") 
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

  describe "Installment Loan Index Pages" do
    
    before(:all) { 
      # Create State table
      10.times { FactoryGirl.create(:state) }
      # Create Sniff table
      FactoryGirl.create(:sniff, id: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, id: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, id: 3, sniff_desc: "Poor") 
      # Create Terms table
      5.times { FactoryGirl.create(:term_loan) }
    } 

    # Installment Loan Main Page
    describe "Installment Loan Main Page" do
      before { 
        # @keyword is the keyword for the page being tested and must be in routes.rb
        @keyword = "installment loans"
        # create installment loan kw MUST be first Factory 
        FactoryGirl.create(
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
        #create child of installment loan should show up
        FactoryGirl.create(
          :keyword,
          word:      "child of term loan",
          phrase:    "child of term loans",
          slug:      "child-of-term-loans",
          state_phrase: "compare child of installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "installment loans",
          controller:  "term"        
        )        
        #create child of payay loans it should not show up
        FactoryGirl.create(
          :keyword,
          word:      "not child of term loan",
          phrase:    "not child of term loans",
          slug:      "not-child-of-term-loans",
          state_phrase: "compare child of installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "payday loans",
          controller:  "term"        
        )                
        visit term_loans_path 
        #puts page.body
      }  

      it { should have_selector('h1', text: 'Installment Loans') }
      it { should have_content('Compare Installment Loans') }

      # tests application_controller set_seo_vars related kw
      it { should have_link("child of term loan", href: "/child-of-term-loan" )}
      it { should_not have_link("not child of term loan", href: "/not-child-of-term-loan" )}
      it_should_behave_like "all index installment loan pages"
      it_should_behave_like "all installment loan pages"
    end  

    #Installment Loan SEO Pages
    describe "Installment Loan SEO Child Pages" do
      before {
        # @keyword is the keyword for the page and must be in routes.rb
        @keyword = "short term installment loans"
        #create child of installment loan should show up
        FactoryGirl.create(
          :keyword,
          word:      "short term installment loans", #child of installment loans
          phrase:    "short term installment loans",
          slug:      "short-term-installment-loans",
          state_phrase: "compare short term installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "installment loans",
          controller:  "term"        
        )        
        #create grand child of installment loans it should show up
        FactoryGirl.create(
          :keyword,
          word:      "grandchild of term loan",
          phrase:    "grandchild of term loans",
          slug:      "grandchild-of-term-loans",
          state_phrase: "compare grandchild of installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "short term installment loans",
          controller:  "term"        
        )                
        FactoryGirl.create(
          :keyword,
          word:      "not grandchild of term loan",
          phrase:    "not grandchild of term loans",
          slug:      "not-grandchild-of-term-loans",
          state_phrase: "compare no grandchild of installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "installment loans",
          controller:  "term"        
        )                
        visit "/short-term-installment-loans/" 
        #puts page.body
      }          

      it { should have_selector('h1', text: 'Short Term Installment Loans') }
      it { should have_content('Compare Short Term Installment Loans') }

      # tests application_controller set_seo_vars related kw
      it { should have_link("grandchild of term loan", href: "/grandchild-of-term-loan" )}
      it { should_not have_link("not grandchild of term loan", href: "/not-grandchild-of-term-loan" )}

      it_should_behave_like "all index installment loan pages"
      it_should_behave_like "all installment loan pages"      
    end

    after(:all){
      Sniff.destroy_all
      State.destroy_all
      TermLoan.destroy_all
      Keyword.destroy_all
    }
  end

  describe "Installment Loan State Pages" do
    before(:all) { 
      FactoryGirl.create(
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
      # Create State table
      FactoryGirl.create(:state, id: 1, state_abbr: "TX", state: "Texas" )
      FactoryGirl.create(:state, id: 2, state_abbr: "VA", state: "Virginia" )
      FactoryGirl.create(:state, id: 3, state_abbr: "CA", state: "California" )
      # Create Sniff table
      FactoryGirl.create(:sniff, id: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, id: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, id: 3, sniff_desc: "Poor") 
      # Create Payday Loan Law
      FactoryGirl.create(:payday_loan_law, state_abbr: "TX", regulator: "TX Regulator")
      FactoryGirl.create(:payday_loan_law, state_abbr: "VA", regulator: "VA Regulator")
      FactoryGirl.create(:payday_loan_law, state_abbr: "CA", regulator: "CA Regulator")
      # Create Terms table
      FactoryGirl.create(:term_loan, id: 1, partner_id: 1, active: true, sniff_id: [1,2,3].sample, ranking:[1,2,3,4,5].sample, image_file: "image", name: "term1", first_comment: "term1 comment", governing_law: "law 1", review_url: "term-loan-1")
      # Create payday_loan_laws table
      FactoryGirl.create(:payday_loan_law, id: 1, state_abbr: "TX", regulator: "TX regulator")
      FactoryGirl.create(:payday_loan_law, id: 2, state_abbr: "VA", regulator: "VA regulator")
      # Create states_term_loans table
      #FactoryGirl.create(:states_term_loans)
      #binding.pry
    } 
    describe "Unlisted State Page" do
      before {
        visit "/installment-loans/fr" 
      }
      it {should have_selector('h1', text: 'Installment Loans') }
      it { should_not have_selector('h2', text: 'Loan Filter') }      
    end

    describe "State Page" do
      before {
        #binding.pry
        @keyword="installment loans"
        visit "/installment-loans/tx"
        #puts page.body
      }

      # keyword in description
      it { should have_css("meta[name='description'][content='Compare Texas installment loans. Search for the lowest fees. Apply direct. Get the best rates in TX at The Payday Hound.']", visible: false) }      
      # Loan Filter in Sidebar
      it { should have_selector('h2', text: 'Loan Filter') }
      it { should have_selector('h1', text: 'Texas') }      
      it "should not have the state selector linking to 50 states" do  
        State.all.each do |s|
          page.should_not have_link(s.state, href:"/#{@keyword.gsub(' ','-')}/#{s.state_abbr.downcase}/") 
        end  
      end 
      it_should_behave_like "all installment loan pages"
    end

    after(:all){
      State.destroy_all
      Sniff.destroy_all
      TermLoan.destroy_all
      Keyword.destroy_all
      PaydayLoanLaw.destroy_all
    }  
  end
    
end

#RAILS_ENV=test rake db:drop db:create db:migrate
#bundle exec rspec spec/requests/term_loans_spec.rb:9
