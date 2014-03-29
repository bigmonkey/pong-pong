require 'spec_helper' 

describe "Banner Model" do 
	it "has a valid term loan banner factory" do
		FactoryGirl.create(:term_loan_banner).should be_valid
	end	

	it "has a valid term payday loan banner factory" do
		FactoryGirl.create(:payday_loan_banner).should be_valid
	end	

	it "should create banners for term lenders" do	
		term_banner = FactoryGirl.create(:term_loan_banner, name: 'term banner')
		TermLoan.find(term_banner.bannerable.id).should_not be_nil
	end

	it "should create banners for payday lenders" do
		payday_banner = FactoryGirl.create(:payday_loan_banner, name: 'payday banner')
		PaydayLoan.find(payday_banner.bannerable.id).should_not be_nil
	end

	it "for term banner is invalid without a partner_id" do
		FactoryGirl.build(:term_loan_banner, partner_id: nil).should_not be_valid
	end 
	it "for term banner is invalid with duplicate partner_id" do
		FactoryGirl.create(:term_loan_banner, partner_id: 2)
		FactoryGirl.build(:term_loan_banner, partner_id: 2).should_not be_valid
	end

	it "for payday banner is invalid without a partner_id" do
		FactoryGirl.build(:payday_loan_banner, partner_id: nil).should_not be_valid
	end 
	it "for payday banner is invalid with duplicate partner_id" do
		FactoryGirl.create(:payday_loan_banner, partner_id: 2)
		FactoryGirl.build(:payday_loan_banner, partner_id: 2).should_not be_valid
	end


after(:all){
	Partner.destroy_all
	PaydayLoan.destroy_all
	TermLoan.destroy_all
	Banner.destroy_all
}
end