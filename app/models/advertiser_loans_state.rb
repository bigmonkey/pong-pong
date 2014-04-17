class AdvertiserLoansState < ActiveRecord::Base
	belongs_to :state
	belongs_to :advertiser_loan	
end
