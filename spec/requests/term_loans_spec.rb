require 'spec_helper'

describe "Installment Loan Pages" do
	subject { page }

  shared_examples_for "all installment loan pages" do
    # keyword in description
    it { should have_css("meta[name='description'][content='Compare #{Keyword.limit(1)[0].phrase}. Search for the lowest fees. Apply direct. Get the best rates at The Payday Hound.']", visible: false) }
    # keyword in title
    it { should have_title("#{Keyword.limit(1)[0].phrase.titleize}") }
    # sidebar
    it { should have_link('Why Use Us', href:"/infos/about/") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}
  end

  shared_examples_for "all index installment loan pages" do

      it "should have the state selector linking to 50 states" do  
        State.all.each do |s|
          page.should have_link(s.state, href:"/#{Keyword.limit(1)[0].slug}/#{s.state_abbr.downcase}/") 
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

end

#RAILS_ENV=test rake db:drop db:create db:migrate
#bundle exec rspec spec/requests/term_loans_spec.rb:9
