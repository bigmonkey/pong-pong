# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :term_loan_banner, class: 'Banner' do
		sequence(:name) { |n| "banner #{n}"} 
		sequence(:partner_id) { |n| n } 
		bannerable factory: :term_loan, sniff_id: 1
  end

  factory :payday_loan_banner, class: 'Banner' do
		sequence(:name) { |n| "banner #{n}"}
		sequence(:partner_id) { |n| n } 		  
		bannerable factory: :payday_loan, sniff_id: 1
  end

end
