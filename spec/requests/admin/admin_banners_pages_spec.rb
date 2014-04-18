require 'spec_helper'

describe "Admin Banner Pages" do
  #CW added this to test when Devise authenticated users are needed
  include Warden::Test::Helpers
  Warden.test_mode!
	
	subject { page }

  describe "Index Page" do
    before(:all) { 
        FactoryGirl.create(:term_loan_banner)
        FactoryGirl.create(:payday_loan_banner)
        FactoryGirl.create(:advertiser_loan_banner)
        Banner.all.count.should eq(3)
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
      Partner.destroy_all #Banner factory creates Partners
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
#      visit admin_banners_path
    end

    after (:each){
      Warden.test_reset! 
    }

    context "All required data filled out", js: true do
      before (:each){  
        @term_lender = FactoryGirl.create(:term_loan, sniff_id:3 )
        visit new_admin_banner_path(lender_type: 'term')
        select @term_lender.name, from: "banner_name"
        fill_in 'banner_lender_link', with: 'http://test.com'
        click_button 'Create Banner' 
      }
      it "clicking on new term banner should land on term page" do 
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

    context "Missing lender link", js: true do
      before (:each){  
        @term_lender = FactoryGirl.create(:term_loan, sniff_id:3 )
        visit new_admin_banner_path(lender_type: 'term')
        select @term_lender.name, from: "banner_name"
        fill_in 'banner_lender_link', with: ""
        click_button 'Create Banner' 
      }
      it "clicking on create banner show error" do 
        page.should have_selector('h2', text: "Banners")
        page.should have_selector('div', text: "Lender link can't be blank")
      end
    end
    context "No lender selected", js: true do
      before (:each){  
        @term_lender = FactoryGirl.create(:term_loan, sniff_id:3 )
        visit new_admin_banner_path(lender_type: 'term')
        click_button 'Create Banner' 
      }
      it "clicking on create banner show error" do 
        page.should have_selector('h2', text: "Banners")
        page.should have_selector('div', text: "Banner NOT created. Please choose a lender.")
      end
    end   

  end
    
  describe "Update a Banner Process" do
    before (:each) do
      user = User.create!({
        :email => 'user@test.com',
        :password => 'happydoggy',
        :password_confirmation => 'happydoggy' 
        })
      login_as(user, scope: :user)
      #visit admin_banners_path
    end

    after (:each){
      Warden.test_reset! 
    }

    context "Update works", js: true do
      before (:each){  
        @banner = FactoryGirl.create(:term_loan_banner)
        visit edit_admin_banner_path(id: @banner)
        click_button 'Update Banner'
      }
      it "clicking on update banner should show update" do 
        page.should have_selector('h2', text: @banner.name)
        page.should have_selector('div', text: 'Banner Updated')
      end
    end
    context "Update fails", js: true do
      before (:each){  
        @banner = FactoryGirl.create(:term_loan_banner)
        visit edit_admin_banner_path(id: @banner)
        fill_in 'banner_lender_link', with: ""
        click_button 'Update Banner'
      }
      it "clicking on udpate banner show error" do 
        page.should have_selector('h2', text: @banner.name)
        page.should have_selector('div', text: "Lender link can't be blank")
      end
    end    
  end


  describe "Delete a Banner" do
    before (:each) do
      user = User.create!({
        :email => 'user@test.com',
        :password => 'happydoggy',
        :password_confirmation => 'happydoggy' 
        })
      login_as(user, scope: :user)
      #visit admin_banners_path
    end

    after (:each){
      Warden.test_reset! 
    }

    context "Delete works", js: true do
      before (:each){  
        @banner = FactoryGirl.create(:term_loan_banner)
        visit admin_banner_path(id: @banner)
        click_link 'Delete Banner'
        #this section handles the pop up
        sleep 1.seconds
        alert = page.driver.browser.switch_to.alert        
        alert.accept
      }
      it "clicking on delete should show delete" do 
        page.should have_selector('h2', text: "Banners")
        page.should have_selector('div', text: 'Banner Deleted')
      end
    end
  end
end