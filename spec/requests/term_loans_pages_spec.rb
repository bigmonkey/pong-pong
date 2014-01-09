require 'spec_helper'

describe "Installment Loan Pages" do
	subject { page }

  shared_examples_for "all installment loan pages" do
    # keyword in title
    it { should have_title("#{@keyword.word.titleize}") }
    # sidebar
    it { should have_link('Why Use Us', href:"/infos/about/") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}
    # check for footer
    it { should have_link('About Us', href:"/infos/about/")}
  end

  shared_examples_for "all index installment loan pages" do
      # keyword in description
      it { should have_css("meta[name='description'][content='Compare #{@keyword.word}. Search for the lowest fees. Apply direct. Get the best rates at The Payday Hound.']", visible: false) }
      it "should have the state selector linking to 50 states" do  
        State.all.each do |s|
          page.should have_link(s.state, href:"/#{@keyword.word.gsub(' ','-')}/#{s.state_abbr.downcase}/") 
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

  describe "Index Pages" do
    
    before(:all) { 
      # Create State table
      10.times { FactoryGirl.create(:state) }
      # Create Sniff table
      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
      # Create Terms table
      #binding.pry
      5.times { FactoryGirl.create(:term_loan) }
    } 

    # Installment Loan Main Page
    context "Main Page" do
      before { 
        # create installment loan kw 
        FactoryGirl.create(
          :keyword,
          word:      "installment loans",
          phrase:    "installment loans",
          state_phrase: "compare installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "installment loans",
        )
        # @keyword is the keyword for the page being tested and must be in routes.rb
        @keyword = Keyword.find_by_word("installment loans")
        #create child of installment loan should show up
        FactoryGirl.create(
          :keyword,
          word:      "child",
          phrase:    "child phrase",
          state_phrase: "compare child of installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "#{@keyword.word}",
        )        
        @child = Keyword.find_by_word("child")
        #create child of payay loans it should not show up
        FactoryGirl.create(
          :keyword,
          word:      "not child",
          phrase:    "not child phrase",
          state_phrase: "compare not child of installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "not #{@keyword.word}",
        )            
        @notchild = Keyword.find_by_word("not child")    
        visit term_loans_path 
        #binding.pry
        #puts page.body
      }  

      it { should have_selector('h1', text: "#{@keyword.phrase.titleize}") }
      it { should have_content("#{@keyword.state_phrase.titleize}") }

      # tests application_controller set_seo_vars related kw
      it { should have_link("#{@child.word}", href: "/#{@child.word.gsub(' ','-')}/" )}
      it { should_not have_link("#{@notchild.word}", href: "/#{@notchild.word.gsub(' ','-')}/" )}
      it_should_behave_like "all index installment loan pages"
      it_should_behave_like "all installment loan pages"
    end  

    #Installment Loan SEO Pages
    context "SEO Child Pages" do
      before {
        #create child of installment loan should show up
        FactoryGirl.create(
          :keyword,
          word:      "short term installment loans", #child of installment loans
          phrase:    "short term installment loans",
          state_phrase: "compare short term installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "installment loans",
          controller: "term"
        ) 
        # @keyword is the keyword for the page and must be in routes.rb
        @keyword = Keyword.find_by_word("short term installment loans")
        #create grand child of payday loans it should show up and child of the @keyword above
        FactoryGirl.create(
          :keyword,
          word:      "grandchild",
          phrase:    "grandchild",
          state_phrase: "compare grandchild",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "#{@keyword.word}",
        )                
        @grandchild = Keyword.find_by_word("grandchild")          
        FactoryGirl.create(
          :keyword,
          word:      "not grandchild",
          phrase:    "not grandchild",
          state_phrase: "compare not grandchild",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "not #{@keyword.word}",
        )                
        @notgrandchild = Keyword.find_by_word("not grandchild")
        #need to re-do routes because routes are based on Keyword table
        Rails.application.reload_routes!
        visit "/#{@keyword.word.gsub(' ','-')}/" 
        #binding.pry
        #puts page.body
      }          

      it { should have_selector('h1', text: "#{@keyword.phrase.titleize}") }
      it { should have_content("#{@keyword.state_phrase.titleize}") }

      # tests application_controller set_seo_vars related kw
      it { should have_link("#{@grandchild.word}", href: "/#{@grandchild.word.gsub(' ','-')}/" )}
      it { should_not have_link("#{@notgrandchild.word}", href: "/#{@notgrandchild.word.gsub(' ','-') }/" )}

      it_should_behave_like "all index installment loan pages"
      it_should_behave_like "all installment loan pages"      
    end

    context "Military Loans" do
      before { 
        FactoryGirl.create(
          :keyword,
          word:      "installment loans",
          phrase:    "installment loans",
          state_phrase: "compare installment loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "installment loans",
        )
        FactoryGirl.create(
          :keyword,
          word:      "military loans",
          phrase:    "military loans",
          state_phrase: "compare military loans",
          category:  "military loans",
          article:   "I'm the article",
          parent_page: "installment loans",
        )        
        FactoryGirl.create(
          :term_loan,
          name:         "military lender",
          lender_type:   "military", 
          first_comment: "military comment 1",
          active: true,
        )
      # need to make route for military loans kw
      Rails.application.reload_routes!
      @keyword = Keyword.find_by_word("military loans")
      visit '/military-loans/'
      }

      it "should not show military lenders with installment loan kw's" do
        #binding.pry
        visit term_loans_path
        #save_and_open_page
        page.should have_content ("installment loans")
        page.should_not have_content("military comment 1")
      end

      it "should show term and military lenders with military loan kw's" do
        #binding.pry
        #save_and_open_page
        page.should have_content ("installment loans")
        page.should have_content("military comment 1")
      end

      it { should have_selector('h1', text: "#{@keyword.phrase.titleize}") }
      it { should have_content("#{@keyword.state_phrase.titleize}") }
      
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

  describe "State Pages" do
    before(:all) { 
      FactoryGirl.create(
        :keyword,
        word:      "installment loans",
        phrase:    "installment loans",
        state_phrase: "compare installment loans",
        category:  "loans",
        article:   "I'm the article",
        parent_page: "installment loans",
      ) 
      # Create State table
      FactoryGirl.create(:state, id: 1, state_abbr: "TX", state: "Texas" )
      FactoryGirl.create(:state, id: 2, state_abbr: "VA", state: "Virginia" )
      FactoryGirl.create(:state, id: 3, state_abbr: "CA", state: "California" )
      # Create Sniff table
      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
      #binding.pry
      # Create Terms table
      #FactoryGirl.create(:term_loan, id: 1, partner_id: 1, active: true, sniff_id: [1,2,3].sample, ranking:[1,2,3,4,5].sample, image_file: "image", name: "term1", first_comment: "term1 comment", governing_law: "law 1", review_url: "term-loan-1")
      # Create payday_loan_laws table
      FactoryGirl.create(:payday_loan_law, id: 1, state_abbr: "TX", regulator: "TX regulator")
      FactoryGirl.create(:payday_loan_law, id: 2, state_abbr: "VA", regulator: "VA regulator")
      # Create states_term_loans table
      #FactoryGirl.create(:states_term_loans)
      #binding.pry
    } 
    context "Unlisted State" do
      before {
        #binding.pry
        visit "/installment-loans/fr" 
      }
      it {should have_selector('h1', text: 'Installment Loans') }
      it { should_not have_selector('h2', text: 'Loan Filter') }      
    end

    context "Listed State" do
      before {
        #binding.pry
        @keyword = Keyword.find_by_word("installment loans")
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
          page.should_not have_link(s.state, href:"/#{@keyword.word.gsub(' ','-')}/#{s.state_abbr.downcase}/") 
        end  
      end 
      it_should_behave_like "all installment loan pages"
    end

    context "Military Loans" do
      before { 
        FactoryGirl.create(
          :keyword,
          word:      "military loans",
          phrase:    "military loans",
          state_phrase: "compare military loans",
          category:  "military loans",
          article:   "I'm the article",
          parent_page: "installment loans",
        )        
        FactoryGirl.create(
          :term_loan,
          name:         "military lender",
          lender_type:   "military", 
          first_comment: "military comment 1",
          active: true,
        )
      # need to make route for military loans kw
      Rails.application.reload_routes!
      @keyword = Keyword.find_by_word("military loans")
      visit '/military-loans/tx'
      }

      # keyword in description
      it { should have_css("meta[name='description'][content='Compare Texas military loans. Search for the lowest fees. Apply direct. Get the best rates in TX at The Payday Hound.']", visible: false) }      
      # Loan Filter in Sidebar
      it { should have_selector('h2', text: 'Loan Filter') }
      it { should have_selector('h1', text: 'Texas') }      
      it "should not have the state selector linking to 50 states" do  
        State.all.each do |s|
          page.should_not have_link(s.state, href:"/#{@keyword.word.gsub(' ','-')}/#{s.state_abbr.downcase}/") 
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
