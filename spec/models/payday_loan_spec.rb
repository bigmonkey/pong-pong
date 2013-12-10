require 'spec_helper' 

describe "PaydayLoan" do 
	it "has a valid factory" do
		FactoryGirl.create(:payday_loan).should be_valid
	end	
	it "is invalid without a partner_id" do
		FactoryGirl.build(:payday_loan, partner_id: nil).should_not be_valid
	end 
	it "in invalid with duplicate partner_id" do
		FactoryGirl.create(:payday_loan, partner_id: 2)
		FactoryGirl.build(:payday_loan, partner_id: 2).should_not be_valid
	end
	describe "filter by sniff level" do
		before {
			@goodlender = FactoryGirl.create(:payday_loan, sniff_id: 1)
			@fairlender = FactoryGirl.create(:payday_loan, sniff_id: 2)
			@badlender = FactoryGirl.create(:payday_loan, sniff_id: 3)			
		}
		it "returns less than equal to sniff level" do
			PaydayLoan.sniff_level(2).should == [@goodlender, @fairlender]
		end	
		it "does not returns greater than sniff level" do
			PaydayLoan.sniff_level(2).should_not include @badlender
		end	
	end
	describe "filter by rank" do
		before {
			@bottomlender = FactoryGirl.create(:payday_loan, ranking: 1)
			@middlelender = FactoryGirl.create(:payday_loan, ranking: 2)
			@higherlender = FactoryGirl.create(:payday_loan, ranking: 3)			
		}		
		it "returns greater than equal to rank level" do
			PaydayLoan.rank_level(2).should == [@middlelender, @higherlender]
		end	
		it "does not return less than to rank level" do
			PaydayLoan.rank_level(2).should_not include @bottomlender
		end	
	end	

	describe "filter by active" do
		before {
			@activelender = FactoryGirl.create(:payday_loan, active: true)
			@inactivelender = FactoryGirl.create(:payday_loan, active: false)
		}
		it "returns active lenders" do
			PaydayLoan.active_lender.should include @activelender
		end	
		it "does not return inactive lenders" do
			PaydayLoan.active_lender.should_not include @inactivelender
		end	
	end	
end