FactoryGirl.define do 

	factory :secured do
		sequence(:name) { |n| "Card #{n}" }
		sequence(:image_file) { |n| "Card #{n}.png" }
		sequence(:rating) { |n| 3 }
		sequence(:first_comment) { |n| "First comment #{n}" }
		sequence(:second_comment) { |n| "Second comment #{n}" }
		sequence(:third_comment) { |n| "Third comment #{n}" }
		sequence(:purchase_apr) { |n| 22.5 }
		sequence(:annual_fee) { |n| 29 }
		sequence(:monthly_fee) { |n| 0 }
		sequence(:cost) { |n| nil }
		sequence(:partner_id) { |n| n }
		sequence(:inst_decision) { |n| TRUE }
		sequence(:card_name) { |n| "card name #{n}" }
		sequence(:bullets) { |n| "<ul><li>Bullet list #{n}</li></ul>" }
		sequence(:issuer) { |n| "Issuer #{n}" }
		sequence(:card_type) { |n| "Mastercard#{n}" }
		sequence(:purchase_base) { |n| "V" }
		sequence(:cash_apr) { |n| 19.99 }
		sequence(:cash_base) { |n| "V" }
		sequence(:grace) { |n| "#{n} days" }
		sequence(:late_fee) { |n| "Up to $#{n+5}" }
		sequence(:return_pmt) { |n|  nil }
		sequence(:overlimit_fee) { |n| "Up to $56" }
		sequence(:max_credit) { |n| 4000 }
		sequence(:min_deposit) { |n| "$49-$200" }
		sequence(:credit_rating) { |n| "poor" }
		sequence(:live) { |n| TRUE }
		sequence(:review_url) { |n| "card-url-#{n}" }
	end		
end