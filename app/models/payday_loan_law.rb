class PaydayLoanLaw < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :state, {:foreign_key => "id"}

end
