require 'spec_helper'

describe "Payday Loan Pages" do
	subject { page }

  shared_examples_for "all payday loan pages" do
    # keyword in title
    it { should have_title("#{@keyword.word.titleize}") }
    # sidebar
    it { should have_link('Find Pre-Approved Lenders Instantly', href:"/why-use-the-payday-hound/") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}
  end

  shared_examples_for "all index payday loan pages" do
      # keyword in description
      it { should have_css("meta[name='description'][content='Compare #{@keyword.word}. Search for the lowest fees. Apply direct. Get the best rates at The Payday Hound.']", visible: false) }
      it "should have the state selector linking to 50 states" do  
        State.all.each do |s|
          page.should have_link(s.state, href:"/#{@keyword.word.gsub(' ','-')}/#{s.state_abbr.downcase}/") 
        end  
      end  

      it "should have table of lenders" do
        #binding.pry
        #save_and_open_page
        PaydayLoan.all.each do |t|
          page.should have_content("Company Name")
          page.should have_selector('div', text: t.first_comment)
          page.should have_link("see review", href: "/lenders/#{t.review_url}/?type=payday" )      
          page.should have_link("Apply Direct", href: "#{partner_path(t.partner_id)}/" )
        end  
      end
  end

  shared_examples_for "all state payday loan pages" do
      # keyword in description
      it { should have_css("meta[name='description'][content='Compare Texas #{@keyword.phrase}. Search for the lowest fees. Apply direct. Get the best rates in TX at The Payday Hound.']", visible: false) }      
      it { should have_selector('h1', text: 'Texas') }      
      it "should not have the state selector linking to 50 states" do  
        State.all.each do |s|
          page.should_not have_link(s.state, href:"/#{@keyword.word.gsub(' ','-')}/#{s.state_abbr.downcase}/") 
        end  
      end 
  end


  describe "Index Pages" do
    
    before (:all){ 
      # Create State table
      10.times { FactoryGirl.create(:state) }
      # Create Sniff table
      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
      # Create Terms table
      5.times { FactoryGirl.create(:payday_loan) }
    } 

    # Payday Loan Main Page
    context "Main Page" do
      before { 
        FactoryGirl.create(
          :keyword,
          word:      "payday loans",
          phrase:    "payday loans",
          state_phrase: "compare payday loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "payday loans",
        )
        # @keyword is the keyword for the page being tested and must be in routes.rb
        @keyword = Keyword.find_by_word("payday loans")
        #create child of payday loan should show up
        FactoryGirl.create(
          :keyword,
          word:      "child",
          phrase:    "child phrase",
          state_phrase: "compare child",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "#{@keyword.word}",
        )        
        @child = Keyword.find_by_word("child")
        #create child of installment loans it should not show up
        FactoryGirl.create(
          :keyword,
          word:      "not child",
          phrase:    "not child",
          state_phrase: "compare not child of payday loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "not #{@keyword.word}",
        )                
        @notchild = Keyword.find_by_word("not child")
        visit payday_loans_path 
        #puts page.body
      }  

      it { should have_selector('h1', text: "#{@keyword.phrase.titleize}") }
      it { should have_content("#{@keyword.state_phrase.titleize}") }

      # tests application_controller set_seo_vars related kw
      it { should have_link("#{@child.word}", href: "/#{@child.word.gsub(' ','-')}/" )}
      it { should_not have_link("#{@notchild.word.gsub(' ','-')}", href: "/#{@notchild.word.gsub(' ','-')}/" )}
      it_should_behave_like "all index payday loan pages"
      it_should_behave_like "all payday loan pages"

      it { should have_selector('div', text: "#{@keyword.word.titleize} Finder") }

    end  

    #Payday Loan SEO Pages
    context "SEO child" do
      before {

        #create child of payday loan should show up
        FactoryGirl.create(
          :keyword,
          word:      "online payday loans", #child of payday loans
          phrase:    "online payday loans",
          state_phrase: "compare online payday loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "payday loans",
          controller: "payday"
        )     
        # @keyword.word is a child of payday loans keyword and must be in routes.rb
        @keyword = Keyword.find_by_word("online payday loans")   
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
        #Rails.application.reload_routes!
        visit "/#{@keyword.word.gsub(' ','-')}/" 
        #binding.pry
        #puts page.body
      }          

      it { should have_selector('h1', text: "#{@keyword.phrase.titleize}") }
      it { should have_content("#{@keyword.state_phrase.titleize}") }

      # tests application_controller set_seo_vars related kw
			it { should_not have_link("#{@notgrandchild.word}", href: "/#{@notgrandchild.word.gsub(' ','-')}/" )}
      it { should_not have_link("#{@notgrandchild.word}", href: "/#{@notgrandchild.word.gsub(' ','-')}/" )}

      it_should_behave_like "all index payday loan pages"
      it_should_behave_like "all payday loan pages"      
    end

    context "SEO pages with varied case URL input" do
      before {

        #create child of payday loan should show up
        FactoryGirl.create(
          :keyword,
          word:      "online payday loans", #child of payday loans
          phrase:    "online payday loans",
          state_phrase: "compare online payday loans",
          category:  "loans",
          article:   "I'm the article",
          parent_page: "payday loans",
          controller: "payday"
        )     
        # @keyword.word is a child of payday loans keyword and must be in routes.rb
        @keyword = Keyword.find_by_word("online payday loans")   
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
        #Rails.application.reload_routes!
        visit "/#{"Online PayDay Loans".gsub(' ','-')}/" 
        #binding.pry
        #puts page.body
      }          

      it { should have_selector('h1', text: "#{@keyword.phrase.titleize}") }
      it { should have_content("#{@keyword.state_phrase.titleize}") }

      # tests application_controller set_seo_vars related kw
      it { should_not have_link("#{@notgrandchild.word}", href: "/#{@notgrandchild.word.gsub(' ','-')}/" )}
      it { should_not have_link("#{@notgrandchild.word}", href: "/#{@notgrandchild.word.gsub(' ','-')}/" )}

      it_should_behave_like "all index payday loan pages"
      it_should_behave_like "all payday loan pages"      
    end

    after(:all){
      PaydayLoan.destroy_all
      State.destroy_all
    }

  end


  describe "State Pages" do
    before (:all){ 
      FactoryGirl.create(
        :keyword,
        word:      "payday loans",
        phrase:    "payday loans",
        state_phrase: "compare payday loans",
        category:  "loans",
        article:   "I'm the article",
        parent_page: "payday loans",
      ) 

      # Create State table
      FactoryGirl.create(:state, id: 1, state_abbr: "TX", state: "Texas" )
      FactoryGirl.create(:state, id: 2, state_abbr: "VA", state: "Virginia" )
      # Create Sniff table
      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 

      #Create Partner table. Every partner has a term loan
      2.times { FactoryGirl.create(:partner) }
      # Create Payday Loan table
      Partner.all.each do |p|
        FactoryGirl.create(:payday_loan, partner_id: p.id)
      end
      # Create payday_loan_laws table
      FactoryGirl.create(:payday_loan_law, id: 1, state_abbr: "TX", regulator: "TX regulator")
      FactoryGirl.create(:payday_loan_law, id: 2, state_abbr: "VA", regulator: "VA regulator")
      # Create payday_loans_state table. Payday Loans only in Texas and not Virginia
      @texaslender=PaydayLoan.first
      @valender=PaydayLoan.last
      FactoryGirl.create(:payday_loans_state, payday_loan_id: @texaslender.id, state_id: State.find_by_state_abbr("TX").id)
      FactoryGirl.create(:payday_loans_state, payday_loan_id: @valender.id, state_id: State.find_by_state_abbr("VA").id)

      #binding.pry
    } 
    context "Unlisted State" do
      before {
        @keyword = Keyword.find_by_word("payday loans")
        visit "/payday-loans/fr" 
      }
      #redirects to main payday loan page
      it {should have_selector('h1', text: ' Loans') }
      it { should_not have_selector('h2', text: 'Loan Filter') } 

      it_should_behave_like "all index payday loan pages"     
    end

    context "Listed State as Texas" do
      before {
        #binding.pry
      	@keyword = Keyword.find_by_word("payday loans")
        visit "/payday-loans/tx"
        #puts page.body
      }      
      it { should have_content("TX Lender") }
      it { should have_selector('div', text: @texaslender.first_comment) }        
      it { should have_link("see review", href: "/lenders/#{@texaslender.review_url}/?type=payday" ) }        
      it { should have_link("Apply Direct", href: "/partners/#{@texaslender.partner_id}/") }
      it "should not show the VA lender" do 
        page.should_not have_link("Apply Direct", href: "/partners/#{@valender.partner_id}/")
      end      

      it_should_behave_like "all state payday loan pages"
      it_should_behave_like "all payday loan pages"
    end

    context "Paid Lenders Exist in TX" do      
      before {
        @keyword = Keyword.find_by_word("payday loans")
        paid_state_lenders = 2
        paid_state_lenders.times do 
          state_lender = FactoryGirl.create(:payday_loan, paid: true, partner_id: FactoryGirl.create(:partner).id)
          FactoryGirl.create(:payday_loans_state, payday_loan_id: state_lender.id, state_id: State.find_by_state_abbr("TX").id)
        end       
        visit "/payday-loans/tx" 
      }
      it { should have_content("#1 Payday Hound Pick -- TX Payday Loans") }
      it { should have_content("#2 Payday Hound Pick -- TX Payday Loans") }
      it { should_not have_css('div.show_728x90')}

    end

    context "Paid Lenders Do Not Exist in TX" do      
      before {
        @keyword = Keyword.find_by_word("payday loans")
        paid_state_lenders = 2
        paid_state_lenders.times do 
          state_lender = FactoryGirl.create(:payday_loan, paid: true, partner_id: FactoryGirl.create(:partner).id)
          FactoryGirl.create(:payday_loans_state, payday_loan_id: state_lender.id, state_id: State.find_by_state_abbr("VA").id)
        end       
        visit "/payday-loans/tx" 
      }
      it { should have_css('div.show_728x90')}
      it { should_not have_content("#1 TX Payday Loans") }
    end

    after(:all){
      State.destroy_all
      Sniff.destroy_all
      PaydayLoan.destroy_all
      Keyword.destroy_all
      PaydayLoanLaw.destroy_all
    }  

  end
    
end
