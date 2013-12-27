require 'spec_helper'

describe "Apply Payday Loan Pages" do

	subject { page }

  shared_examples_for "all apply pages" do
    # keyword in title
    it { should have_title("Get a Payday Loan") }
    # paday Nav Bar
    it { should have_link('Apply', href:"/get-payday-loan/")}
    # check for footer
    it { should have_link('About Us', href:"/infos/about/")}
  end

	describe "Index" do
		before { visit applicants_path }

		it { should have_selector('h1', text: 'How Much Cash Do You Need') }
		# sidebar
		it { should have_selector('li', text: "Private") }
		it { should have_selector('h1', text: "What Happens Next")}
		it_should_behave_like "all apply pages"

		describe "Application" do
			# if fails to connect to Firefox check selenium webdriver gem version
			context "state and bank account filled in" do
				it "goes to application", js: true do
					select "Texas", from: "state"
					select "Checking", from: "bank_account_type"
					click_button "Find a Loan"
					page.should have_selector('div', text: 'Congratulations!')
				end
			end
			context "state not filled in" do
				it "stays in filter", js: true do
					select "Checking", from: "bank_account_type"
					click_button "Find a Loan"
					page.should_not have_selector('h1', text: 'Congratulations')
				end
			end
			context "bank_account_type not filled in" do
				it "stays in filter", js: true do
					select "Texas", from: "state"
					click_button "Find a Loan"
					page.should_not have_selector('h1', text: 'Congratulations')
				end
			end
		end
	end
end