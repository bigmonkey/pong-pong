class Partner < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :term_loan
  has_one :payday_loan
end
