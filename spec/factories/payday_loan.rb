FactoryGirl.define do
	factory :payday_loan do
		sequence(:partner_id) { |n| n }
		sequence(:active) { |n| true }
		sequence(:sniff_id) { |n| Sniff.find_by_sniff_desc(['Great','Fair','Bad'].sample).id } 
		sequence(:ranking) { |n| [1,2,3,4,5].sample }
		sequence(:image_file) { |n| "image#{n}"}
		sequence(:name) { |n| "Payday Lender #{n}"}
		sequence(:first_comment) { |n| "first comment #{n}"}
		sequence(:governing_law) { |n| "law #{n}"}
		sequence(:review_url) { |n| "payday-loan-url#{n}"}
		sequence(:lender_type) { |n| "payday"}		
		sequence(:cost) { |n| 100*n}
	end	
end