class PaydayLoansState < ActiveRecord::Base
	belongs_to :state
	belongs_to :payday_loan
end