class Partner < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :term_loan
  has_one :payday_loan
  has_one :banner

  validates :lender_link, presence: true
end
