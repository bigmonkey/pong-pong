FactoryGirl.define do 

	factory :sniff do
		id 	""
		sniff_desc 	""
	end	

	factory :state do
		sequence(:id) { |n| n} 
		sequence(:state_abbr) { |n| n<10 ? "a#{n}".upcase : "#{n}".upcase  }
		sequence(:state) { |n| "State #{n}" }
	end	

	#factory :states_term_loans, :parent => :state do
	#	term_loans {[FactoryGirl.create(:term_loan)]}
	#end
		
	factory :keyword do
		word			"installment loans"
		phrase		"installment loans |plural for copy"
		slug			"installment-loans"
		state_phrase "compare installment loans |for state selector verb and plural"
		category	"loans |selects copy on index"
		article		"I'm the article"
		parent_page	"installment loans |where it gets shown"
		controller	"term |not used but maybe in routes"
	end
	
	factory :payday_loan_law do
		id ""
		state_abbr ""
		name ""
		regulator ""
		legal_status ""
	end	

	factory :payday_loan_law_detail do 
		id ""
		state_abbr ""
		ncsl_citation ""
	end

	factory :partner do
		lender_link "http://lender_link.com"
		lender_tail ""
	end

end

