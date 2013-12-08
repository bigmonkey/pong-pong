class Sniff < ActiveRecord::Base
  # attr_accessible :title, :body
  
  has_many :lenders
  has_many :term_loans
  has_many :payday_loans
  
end
