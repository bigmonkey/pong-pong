require 'spec_helper'

describe "Installment Loan Pages" do
	subject { page }

  shared_examples_for "all installment loan pages" do
  	# payday app menu is not showing

		it { should have_css('title', :text => "#{@keyWord}") }   
  end

  describe "Installment Loan Page" do
    
    before { 
      3.times { FactoryGirl.create(:sniff) } 

    	visit term_loans_path 
    }
    it_should_behave_like "all installment loan pages"
  end

end
