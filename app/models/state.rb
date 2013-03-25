class State < ActiveRecord::Base
  # attr_accessible :title, :body
  
  has_and_belongs_to_many :lenders
  has_and_belongs_to_many :payday_loans
  has_and_belongs_to_many :term_loans
  has_one :payday_loan_law, {:foreign_key => "id"}
  has_one :payday_loan_law_detail, {:foreign_key => "id"}
  
    def self.select_state_(id)
		where("state_id = ?", id)
    end
      
end
