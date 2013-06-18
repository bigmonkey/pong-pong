require 'spec_helper'

describe "Secured Card Pages" do
	subject { page }

  shared_examples_for "all secured card pages" do
  	# payday app menu is not showing
    it { should_not have_content('application [+]') }
  end

  describe "Ranking Page" do
    before { 
        num_cards = 2
        num_cards.times { FactoryGirl.create(:secured) }
        Secured.live.size.should eq(num_cards)
        visit secureds_path 
        # puts page.body
    }
    # prepaid-cards routing
    it { should have_selector('h1', text: 'Secured Credit Cards') }
    # chooser is showing
    it { should have_content('Compare Cards') }
  
    # cards are showing
    it "should list each secured credit card" do
      Secured.all.each do |s|
        page.should have_content("Company Name")
        page.should have_selector('div', text: s.first_comment)
        page.should have_link(s.name, href: secured_path(s.review_url))
      end
    end
    it_should_behave_like "all secured card pages"
  end

  describe "Individual Secured Card Pages" do
    let(:secured) { FactoryGirl.create(:secured) }
    before { visit secured_path(secured.review_url) }

    it { should have_content('Compare Cards') }
    it { should have_content(secured.card_name) }
    it { should have_content(secured.first_comment) }
    it { should have_content(secured.purchase_apr) }
    #it { should have_content(secured.bullets) }  #how to test raw content inside cell
    it_should_behave_like "all secured card pages"
  end

end