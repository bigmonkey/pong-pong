# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :advertiser_loan do
		sequence(:partner_id) { |n| FactoryGirl.create(:partner).id }
		sequence(:active) { |n| true }
		sequence(:sniff_id) { |n| FactoryGirl.create(:sniff, sniff_desc: ['Great','Fair','Bad'].sample).id } 
		sequence(:ranking) { |n| [1,2,3,4,5].sample }
		sequence(:name) { |n| "Advertiser Lender #{n}"}
  end
end
