require 'spec_helper' 

describe "AdvertiserLoan Model" do 

	it "has a valid factory" do
		FactoryGirl.create(:advertiser_loan).should be_valid
	end	
	it "is invalid without a partner_id" do
		FactoryGirl.build(:advertiser_loan, partner_id: nil).should_not be_valid
	end 
	it "in invalid with duplicate partner_id" do
		FactoryGirl.create(:advertiser_loan, partner_id: 2)
		FactoryGirl.build(:advertiser_loan, partner_id: 2).should_not be_valid
	end
	describe "filter by sniff level" do
		before {
			@goodlender = FactoryGirl.create(:advertiser_loan, sniff_id: FactoryGirl.create(:sniff, sniff_score: 1).id)
			@fairlender = FactoryGirl.create(:advertiser_loan, sniff_id: FactoryGirl.create(:sniff, sniff_score: 2).id)
			@badlender = FactoryGirl.create(:advertiser_loan, sniff_id: FactoryGirl.create(:sniff, sniff_score: 3).id)			
		}
		it "returns less than equal to sniff level" do
			AdvertiserLoan.sniff_level(2).should == [@goodlender, @fairlender]
		end	
		it "does not returns greater than sniff level" do
			AdvertiserLoan.sniff_level(2).should_not include @badlender
		end	
	end
	describe "filter by rank" do
		before {
			@bottomlender = FactoryGirl.create(:advertiser_loan, ranking: 1)
			@middlelender = FactoryGirl.create(:advertiser_loan, ranking: 2)
			@higherlender = FactoryGirl.create(:advertiser_loan, ranking: 3)			
		}		
		it "returns greater than equal to rank level" do
			AdvertiserLoan.rank_level(2).should == [@middlelender, @higherlender]
		end	
		it "does not return less than to rank level" do
			AdvertiserLoan.rank_level(2).should_not include @bottomlender
		end	
	end	

	describe "filter by active" do
		before {
			@activelender = FactoryGirl.create(:advertiser_loan, active: true)
			@inactivelender = FactoryGirl.create(:advertiser_loan, active: false)
		}
		it "returns active lenders" do
			AdvertiserLoan.active_lender.should include @activelender
		end	
		it "does not return inactive lenders" do
			AdvertiserLoan.active_lender.should_not include @inactivelender
		end	
	end	

	after(:all){
		Sniff.destroy_all
		AdvertiserLoan.destroy_all
	}
end