# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do


  factory :term_loan_banner, class: 'Banner' do
		name "banner name"
		partner factory: :partner    
		bannerable factory: :term_loan, sniff_id: 1
  end

  factory :payday_loan_banner, class: 'Banner' do
		name "banner name"
		partner factory: :partner 		  
		bannerable factory: :payday_loan, sniff_id: 1
  end

  factory :advertiser_loan_banner, class: 'Banner' do
		name "banner name"
		partner factory: :partner 		  
		bannerable factory: :advertiser_loan, sniff_id: 1
  end

end
