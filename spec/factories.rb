FactoryGirl.define do 
	factory :prepaid do
		sequence(:partner_id) { |n| n}
		sequence(:name) { |n| "Card #{n}"}
		sequence(:image_file) { |n| "card#{n}.jpg" }
		sequence(:card_name) { |n| "card name #{n}"}
		sequence(:credit_needed) { |n| "no credit needed" }
		sequence(:first_comment) { |n| "first comment #{n}"}
		sequence(:second_comment) { |n| "second comment #{n}"}
		sequence(:third_comment) { |n| "third comment #{n}"}
		sequence(:activation_fee) { |n| 4.95}
		sequence(:reduce_mth_fee_load_amt) { |n| nil}
		sequence(:reduce_mth_fee) { |n| nil }
		sequence(:mth_fee_dep) { |n| 7.95 }
		sequence(:mth_fee_no_dep) { |n| 7.95 }
		sequence(:trans_fee_signature) { |n| 0 }
		sequence(:atm_bal_fee) { |n| 1 }
		sequence(:atm_out_net_fee) { |n| 2.5 }
		sequence(:atm_in_net_fee_dep) { |n| nil }
		sequence(:atm_in_net_fee_no_dep) { |n| nil }
		sequence(:load_fee) { |n| 3.95 }
		sequence(:paper_statement) { |n| nil }
		sequence(:max_atm) { |n| 500 }
		sequence(:max_bal) { |n| 10000 }
		sequence(:max_daily_spend) { |n| 2000 }
		sequence(:min_load) { |n| nil }
		sequence(:max_cash_deposit) { |n| 1500 }
		sequence(:bill_pay_elec) { |n| "Free" }
		sequence(:bill_pay_paper) { |n| "Free" }
		sequence(:online_acct) { |n| "Free" }
		sequence(:call_fee_dep) { |n| 0 }
		sequence(:call_fee_no_dep) { |n| 0 }
		sequence(:free_calls) { |n| 0 }
		sequence(:call_center_desc) { |n| "Call Center Desc #{n}" }
		sequence(:bullets) { |n| "<ul><li>Bullet list #{n}</li></ul>" }
		sequence(:issuer) { |n| "Isser #{n}" }
		sequence(:live) {|n| true}
		sequence(:rating) {|n| 1}
	end
end

