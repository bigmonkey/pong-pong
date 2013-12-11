FactoryGirl.define do 
	factory :applicant do
		requested_amount 300
		state "TX"
		bank_account_type "Checking"
		active_military "false"
		eighteen "true"
	end
end	