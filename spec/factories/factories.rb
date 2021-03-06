FactoryGirl.define do 

	factory :sniff do
		sniff_desc 	""
		sniff_score ""
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
		word			"short term installment loans"
		phrase		"short term installment loans"
		state_phrase "compare short term installment loans"
		category	"loans"
		article		"I'm the article"
		parent_page	"installment loans"
		controller	"term"
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
		sequence(:lender_link) { |n| "http://lender_link_#{n}.com" }
		sequence(:lender_tail) { |n| ""}
		sequence(:name) { |n| "partner #{n}"}
	end

	factory :payday_loans_state do
		payday_loan_id ""
		state_id ""
		loan_amt ""
		cost ""
		apr ""
	end

	factory :states_term_loan do
		term_loan_id ""
		state_id ""
	end

	factory :advertiser_loans_state do
		advertiser_loan_id ""
		state_id ""
	end	

  factory :topic do
  	sequence(:topic) { |n| "Topic #{n}" }
  	sequence(:slug) { |n| "topic-slug-#{n}"}
  end

	factory :posts_topic do
		post_id ""
		topic_id ""
	end

end

