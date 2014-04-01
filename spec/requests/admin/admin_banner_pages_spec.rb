require 'spec_helper'

describe "Admin Banner Pages" do
  #CW added this to test when Devise authenticated users are needed
  include Warden::Test::Helpers
  Warden.test_mode!
	
	subject { page }

  describe "Index Page" do
    before(:all) { 
        num_banners = 4
        (num_banners/2).times do
          partner = FactoryGirl.create(:partner)
          FactoryGirl.create(:term_loan_banner, partner: partner)
        end
        (num_banners/2).times do
          partner = FactoryGirl.create(:partner)
          FactoryGirl.create(:payday_loan_banner, partner: partner)
        end
        Banner.all.count.should eq(num_banners)
    }

    before (:each) do
      user = User.create!({
        :email => 'user@test.com',
        :password => 'happydoggy',
        :password_confirmation => 'happydoggy' 
        })
      login_as(user, scope: :user)
      visit admin_banners_path
    end

    after (:each){
      Warden.test_reset! 
    }

    it { should have_content("New Term Banner") }
    it { should have_selector('h2', text: 'Banners') }


    it "should list each banner" do
      Banner.all.each do |s|
        page.should have_content(s.name)
      end
    end

    it "should link to add term loan banner", js: true do
      click_link "New Term Banner"
      page.should have_selector('h2', text: 'New Banner')
      page.should have_content("Choose Term Lender Name")
    end

    after(:all) {
      Partner.destroy_all
      Banner.destroy_all
    }
  end

  describe "Add a Banner Process" do
    before (:each) do
      user = User.create!({
        :email => 'user@test.com',
        :password => 'happydoggy',
        :password_confirmation => 'happydoggy' 
        })
      login_as(user, scope: :user)
      visit admin_banners_path
    end

    after (:each){
      Warden.test_reset! 
    }

    describe "Describe Add a Banner" do
      context "All required data filled out", js: true do
        before (:each){  
          @partner = FactoryGirl.create(:partner)
          @term_lender = FactoryGirl.create(:term_loan, partner: @partner, sniff_id:3 )
          visit new_admin_banner_path(lender_type: 'term')
          select @term_lender.name, from: "banner_name"
          fill_in 'banner_lender_link', with: 'http://test.com'
          click_button 'Create Banner' 
        }

        it "clicking on new term banner should land or term page" do 
          page.should have_selector('h2', text: "#{@term_lender.name} 160x600")
          page.should have_selector('div', text: 'New banner create')
        end
        it "should create a Partner" do
          page.should have_link("#{@term_lender.name} 160x600", href:"/admin/partners/#{Partner.find_by_name(@term_lender.name + ' 160x600').id}")
        end
        it "should link to a Term lender" do
          Banner.find_by_name("#{@term_lender.name} 160x600").bannerable.id.should eq(@term_lender.id)
        end
        it "should be linked to by a Term Lender" do
          @term_lender.banners.find_by_name("#{@term_lender.name} 160x600").name.should eq ("#{@term_lender.name} 160x600")
        end

      end
    end
  end
    

end