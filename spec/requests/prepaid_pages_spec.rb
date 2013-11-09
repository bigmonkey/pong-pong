require 'spec_helper'

describe "Prepaid Pages" do
	subject { page }

  shared_examples_for "all prepaid pages" do
  	# payday app menu is not showing
    it { should_not have_content('application [+]') }
  end

  describe "Ranking Page" do
    before { 
        num_cards = 5
        num_cards.times { FactoryGirl.create(:prepaid) }
        Prepaid.live.size.should eq(num_cards)
        visit prepaids_path 
        #puts page.body
    }
    # prepaid-cards routing
    it { should have_selector('h1', text: 'Prepaid Cards') }
    # chooser is showing
    it { should have_content('Compare Cards') }
  
    # cards are showing
    it "should list each prepaid card" do
      Prepaid.all.each do |p|
        page.should have_content("Company Name")
        page.should have_selector('div', text: p.first_comment)
        page.should have_link(p.name, href: prepaid_path(p.review_url))
        page.should have_link("SIGN UP", href: partner_path(p.partner_id))
      end
    end
    it_should_behave_like "all prepaid pages"
  end

  describe "Individual Prepaid Card Pages" do
    let(:prepaid) { FactoryGirl.create(:prepaid) }
    before { visit prepaid_path(prepaid.review_url) }

    it { should have_content('Compare Cards') }
    it { should have_content(prepaid.card_name) }
    it { should have_content(prepaid.first_comment) }
    it { should have_content(prepaid.activation_fee) }
    it { should have_link("Sign Up", href: partner_path(prepaid.partner_id)) }
    #it { should have_content(prepaid.bullets) }  #how to test raw content inside cell
    it_should_behave_like "all prepaid pages"
  end

end

