require 'spec_helper'

describe "Installment Loan Pages" do
	subject { page }

  shared_examples_for "all installment loan pages" do
  	# payday app menu is not showing
		#it { should have_css('title', :text => "Payday Loans") }
    it { should have_title 'Payday Loans' }   
  end

  describe "Installment Loan Page" do
    
    before { 
      3.times { FactoryGirl.create(:sniff) } 
      @keyword = FactoryGirl.create(:keyword)


      visit term_loans_path 
      # puts page.body
      binding.pry
    }
    it_should_behave_like "all installment loan pages"
  end

end

#RAILS_ENV=test rake db:drop db:create db:migrate
#bundle exec rspec spec/requests/term_loans_spec.rb:9
