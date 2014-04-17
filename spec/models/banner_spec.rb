require 'spec_helper' 

describe "Banner Model" do 
	describe "Test Factory" do
		it "has a valid term loan banner factory" do
			FactoryGirl.create(:term_loan_banner).should be_valid
		end		

		it "has a valid term payday loan banner factory" do
			FactoryGirl.create(:payday_loan_banner).should be_valid
		end

		it "has a valid advertiser banner factory" do
			FactoryGirl.create(:advertiser_loan_banner).should be_valid
		end				
	end
		
	describe "Create Banner" do
		it "should work for term lenders" do	
			term_banner = FactoryGirl.create(:term_loan_banner, name: 'term banner')
			TermLoan.find(term_banner.bannerable.id).should_not be_nil
		end	

		it "should work for payday lenders" do
			payday_banner = FactoryGirl.create(:payday_loan_banner, name: 'payday banner')
			PaydayLoan.find(payday_banner.bannerable.id).should_not be_nil
		end

		it "should work for advertiser" do
			advertiser_banner = FactoryGirl.create(:advertiser_loan_banner, name: 'advertiser banner')
			AdvertiserLoan.find(advertiser_banner.bannerable.id).should_not be_nil
		end
	end
		
	describe "Validity" do
		it "term banner is invalid without a partner_id" do
			FactoryGirl.build(:term_loan_banner, partner_id: nil).should_not be_valid
		end 	

		it "term banner is invalid with duplicate partner_id" do
			FactoryGirl.create(:term_loan_banner, partner_id: 2)
			FactoryGirl.build(:term_loan_banner, partner_id: 2).should_not be_valid
		end	

		it "payday banner is invalid without a partner_id" do
			FactoryGirl.build(:payday_loan_banner, partner_id: nil).should_not be_valid
		end 
		it "for payday banner is invalid with duplicate partner_id" do
			FactoryGirl.create(:payday_loan_banner, partner_id: 2)
			FactoryGirl.build(:payday_loan_banner, partner_id: 2).should_not be_valid
		end

		it "for advertiser banner is invalid without a partner_id" do
			FactoryGirl.build(:advertiser_loan_banner, partner_id: nil).should_not be_valid
		end 
		it "for advertiser banner is invalid with duplicate partner_id" do
			FactoryGirl.create(:advertiser_loan_banner, partner_id: 2)
			FactoryGirl.build(:advertiser_loan_banner, partner_id: 2).should_not be_valid
		end		
	end

after(:all){
	Partner.destroy_all
	PaydayLoan.destroy_all
	TermLoan.destroy_all
	AdvertiserLoan.destroy_all
	Banner.destroy_all
}
end