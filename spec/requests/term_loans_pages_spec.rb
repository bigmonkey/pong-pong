require 'spec_helper'

describe "Installment Loan Pages" do
	subject { page }

  shared_examples_for "all installment loan pages" do
    # keyword in title
    it { should have_title("#{@keyword.word.titleize}") }
    # sidebar
    it { should have_link('Pre-Approved Lenders', href:"/why-use-the-payday-hound/") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}


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
          page.should have_link("see review", href: "/lenders/#{t.review_url}/" )      
          page.should have_link("Apply", href: "#{partner_path(t.partner_id)}/" )
        end  
      end
  end

  shared_examples_for "all state installment loan pages" do
      # keyword in description
      it { should have_css("meta[name='description'][content='Compare Texas #{@keyword.phrase}. Search for the lowest fees. Apply direct. Get the best rates in TX at The Payday Hound.']", visible: false) }      
      it { should have_selector('h1', text: 'Texas') }      
      it "should not have the state selector linking to 50 states" do  
        State.all.each do |s|
          page.should_not have_link(s.state, href:"/#{@keyword.word.gsub(' ','-')}/#{s.state_abbr.downcase}/") 
        end  
      end 
  end

  shared_examples_for "non-content ad pages" do 
    it "should not show side bar loan selector" do
      save_and_open_page
      page.should_not have_selector('h2',text: 'Get Quick Cash')
    end
  end

  describe "Index Pages" do
    
    before(:all) { 
      # Create State table
      5.times { FactoryGirl.create(:state) }
      # Create Sniff table
      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
      # Create Terms table
      #binding.pry
      3.times { FactoryGirl.create(:term_loan) }
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

      # below is for loanfinder, the one below is for loanDrop
      it { should have_selector('div', text: "#{@keyword.word.titleize} Finder") }
      #it { should have_selector('h2', text: "Get Quick Cash") }

      it_should_behave_like "non-content ad pages"      

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
      it_should_behave_like "non-content ad pages"      
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
      # Rails.application.reload_routes! needed when KW table was used to generate routes
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
      it_should_behave_like "non-content ad pages"         
    end

    # Installment Loan Content Ad Pages
    context "Content Ad Page" do
      before { 
        # create installment loan kw 
        FactoryGirl.create(
          :keyword,
          word:      "borrow money options",
          phrase:    "borrow money options",
          state_phrase: "evaluate borrow money options",
          category:  "custom",
          article:   "Here are some borrow money options.",
          parent_page: "",
        )
        # @keyword is the keyword for the page being tested and must be in routes.rb
        @keyword = Keyword.find_by_word("borrow money options")
        #binding.pry
        visit '/borrow-money-options/'
        #binding.pry
        #puts page.body
      }  

      it { should have_selector('h1', text: "#{@keyword.phrase.titleize}") }

      it "should have loan finder sidebar " do
        page.should have_selector('h2', 'Get Quick Cash') 
      end


    end  

    after(:all){
      Sniff.destroy_all
      State.destroy_all
      TermLoan.destroy_all
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
      # Create Sniff table
      FactoryGirl.create(:sniff, sniff_score: 1, sniff_desc: "Great") 
      FactoryGirl.create(:sniff, sniff_score: 2, sniff_desc: "Fair") 
      FactoryGirl.create(:sniff, sniff_score: 3, sniff_desc: "Bad") 
      #binding.pry
      #Create Partner table. Every partner has a term loan
      2.times { FactoryGirl.create(:partner) }
      # Create Term Loan table
      Partner.all.each do |p|
        FactoryGirl.create(:term_loan, partner_id: p.id)
      end
      # Create payday_loan_laws table
      FactoryGirl.create(:payday_loan_law, id: 1, state_abbr: "TX", regulator: "TX regulator")
      FactoryGirl.create(:payday_loan_law, id: 2, state_abbr: "VA", regulator: "VA regulator")
      # Create states_term_loans table. Term Loans only in Texas and not Virginia
      @texaslender=TermLoan.first
      @valender=TermLoan.last
      FactoryGirl.create(:states_term_loan, term_loan_id: @texaslender.id, state_id: State.find_by_state_abbr("TX").id)
      FactoryGirl.create(:states_term_loan, term_loan_id: @valender.id, state_id: State.find_by_state_abbr("VA").id)
      #binding.pry
    } 
    context "Unlisted State" do
      before {
        #binding.pry
        @keyword = Keyword.find_by_word("installment loans")
        visit "/installment-loans/fr" 
      }
      #redirects to main installment page
      it {should have_selector('h1', text: 'Installment Loans') }
      it { should_not have_selector('h2', text: 'Loan Filter') }  

      it_should_behave_like "all index installment loan pages"    
    end

    context "Listed State as TX" do
      before {
        #binding.pry
        @keyword = Keyword.find_by_word("installment loans")
        visit "/installment-loans/tx"
        #puts page.body
      }

      it { should have_content("TX Lender") }
      it { should have_selector('div', text: @texaslender.first_comment) }        
      it { should have_link("see review", href: "/lenders/#{@texaslender.review_url}/" ) }         
      it { should have_link("Apply", href: "/partners/#{@texaslender.partner_id}/") }
      it "should not show the VA lender" do 
        page.should_not have_link("Apply", href: "/partners/#{@valender.partner_id}/")
      end      

      it_should_behave_like "all state installment loan pages"
      it_should_behave_like "all installment loan pages"
    end

    context "Paid Lenders Exist in TX" do      
      before {
        @keyword = Keyword.find_by_word("installment loans")
        paid_state_lenders = 2
        paid_state_lenders.times do 
          state_lender = FactoryGirl.create(:term_loan, paid: true, partner_id: FactoryGirl.create(:partner).id)
          FactoryGirl.create(:states_term_loan, term_loan_id: state_lender.id, state_id: State.find_by_state_abbr("TX").id)
        end       
        advertiser_banner = FactoryGirl.create(:advertiser_loan_banner, rotation_rank: 5)
        FactoryGirl.create(:advertiser_loans_state, advertiser_loan_id: advertiser_banner.bannerable.id, state_id: State.find_by_state_abbr("TX").id)         
        visit "/installment-loans/tx" 
      }
      it { should have_content("#1 Payday Hound Pick") }
      it { should have_content("#2 Payday Hound Pick") }
      it "should have h2 selectors for paid lenders" do 
        State.find_by_state_abbr('TX').term_loans.paid.by_top_rank.first(2).each do |l|
          page.should have_selector("h2", text: "#{l.name.titleize}")      
        end
      end  
      it { should have_css('div.show_728x90')}      
      it { should have_css('div.show_160x600')}
    end

    describe "Paid Term Lenders" do      
      before {
        @keyword = Keyword.find_by_word("installment loans")
        paid_state_lenders = 2
        paid_state_lenders.times do 
          state_lender = FactoryGirl.create(:term_loan, paid: true, partner_id: FactoryGirl.create(:partner).id)
          FactoryGirl.create(:states_term_loan, term_loan_id: state_lender.id, state_id: State.find_by_state_abbr("VA").id)
        end       
      }

      context "Do not exist in TX" do
        before { visit "/installment-loans/tx" }
        it { should_not have_content("#1 TX Installment Loans") }
        it { should have_css('div.show_728x90')}  
      end
      
      context "Do not exit in TX. Payday, and Advertisers do not exist in TX" do
        before { visit "/installment-loans/tx" }
        it { should have_css('div.show_160x600')}
      end      

      context "Do not exisit in TX but an advertisers exists in TX " do
        before {
          advertiser_banner = FactoryGirl.create(:advertiser_loan_banner, rotation_rank: 5)
          FactoryGirl.create(:advertiser_loans_state, advertiser_loan_id: advertiser_banner.bannerable.id, state_id: State.find_by_state_abbr("TX").id)
          visit "/installment-loans/tx"
        }
        it { should have_css('div.show_160x600')}
      end

      context "Do not exisit in TX but an Payday Lender exists in TX " do
        before {
          term_banner = FactoryGirl.create(:payday_loan_banner, rotation_rank: 5)
          FactoryGirl.create(:payday_loans_state, payday_loan_id: term_banner.bannerable.id, state_id: State.find_by_state_abbr("TX").id)
          visit "/installment-loans/tx"
        }
        it { should have_css('div.show_160x600')}
      end      
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
        TermLoan.destroy_all
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

      it_should_behave_like "all state installment loan pages"
      it_should_behave_like "all installment loan pages"
    end    

    after(:all){
      Sniff.destroy_all
      State.destroy_all
      TermLoan.destroy_all
      Keyword.destroy_all
      Partner.destroy_all
      PaydayLoanLaw.destroy_all
      StatesTermLoan.destroy_all
    }

  end
    
end

#RAILS_ENV=test rake db:drop db:create db:migrate
#bundle exec rspec spec/requests/term_loans_spec.rb:9
