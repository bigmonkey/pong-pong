class StatesTermLoan < ActiveRecord::Base
	belongs_to :state
	belongs_to :term_loan
end