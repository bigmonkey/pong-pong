require 'spec_helper'

describe "Prepaid Pages" do
	subject { page }

  shared_examples_for "all prepaid pages" do
  	# payday app menu is not showing
    it { should_not have_content('application [+]') }
    # sidebar
    it { should have_link('Find Pre-Approved Lenders Instantly', href:"/why-use-the-payday-hound/") }
    # Nav Bar
    it { should have_link('Learn', href:'#')}
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}

  end

  describe "Main Page" do
    before(:all) { 
        num_cards = 5
        num_cards.times { FactoryGirl.create(:prepaid) }
        Prepaid.live.size.should eq(num_cards) 
        
        #binding.pry
    }
    before {
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
        page.should have_link(p.name, href: "#{prepaid_path(p.review_url)}/")
        page.should have_link("SIGN UP", href: "#{partner_path(p.partner_id)}/")
      end
    end
    # number of cards in title 
    it { should have_title("#{Prepaid.live.size} Prepaid") }

    it_should_behave_like "all prepaid pages"

    after(:all){
      Prepaid.destroy_all
    }
  end

  describe "Individual Cards" do
    let(:prepaid) { FactoryGirl.create(:prepaid) }
    before { visit prepaid_path(prepaid.review_url) }

    it { should have_content('Compare Cards') }
    it { should have_content(prepaid.card_name) }
    it { should have_content(prepaid.first_comment) }
    it { should have_content(prepaid.activation_fee) }
    it { should have_link("Sign Up", href: "#{partner_path(prepaid.partner_id)}/") }
    #it { should have_content(prepaid.bullets) }  #how to test raw content inside cell
    # keyword in title 
    it { should have_title("#{prepaid.name}") }
    
    it_should_behave_like "all prepaid pages"
    after(:all){ Prepaid.destroy_all}

  end

end

