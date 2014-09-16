require 'spec_helper'

describe "Posts" do
	subject { page }

    before(:all) {
      16.times { FactoryGirl.create(:post) }
      @recent_posts = Post.created.first(10)
      3.times { FactoryGirl.create(:topic) }
      @topics = Topic.all
    }  

    after(:all) {
      Post.destroy_all
      Topic.destroy_all
    }

  shared_examples_for "post pages" do

    it { should have_css("meta[name='description']", visible: false) }
    it { should have_css("title", visible:false)}

    # sidebar
    it { should have_selector('h2', text:"Learn") }
    it "should list first category" do
      page.should have_link(@topics.first.topic, href:"/learn/category/#{@topics.first.slug}/")
    end

    it { should have_selector('h2', text:"Recent Posts") }
    it "should list the 2nd most recent post" do
      page.should have_link(@recent_posts[1].title, href:"/learn/#{@recent_posts[1].slug}/")
    end
    # Nav Bar
    it { should have_link('Learn', href:'#')}
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}

  end

  describe "Index" do

    before {
      visit posts_path
      #puts page.body
    }

    it { should have_selector('h1')}    

    describe "Pagination" do
      # nav tag is created by kaminari gem
      it { should have_selector('nav.pagination') }

      it "should list each post" do
        Post.created.page(1).per(5).each do |post|
          page.should have_selector('h1',text: post.title)
          page.should have_content(post.updated_at.strftime("%B %d, %Y"))
          page.should have_content(post.article)   
        end
      end
    end

    it_should_behave_like "post pages"

  end

  describe "Posts" do
    
    before { 
      @current_post = Post.first
      visit post_path(@current_post.slug)
      #puts page.body
    }

    # seo title and description should be use
    it { should have_css("meta[name='description'][content='#{@current_post.description}']", visible: false) }
    it { should have_title("#{@current_post.seo_title} | The Payday Hound")}   

    # author schema
    it { should have_css("div[itemtype='http://schema.org/Article']", visible: false)}
    it { should have_css("span[itemprop='name']", visible: false)}
    it { should have_css("span[itemprop='dateModified']", visible: false)}
    it { should have_css("span[itemprop='datePublished']", visible: false)}

    #content
    it {should have_selector('h1', text: @current_post.title)}
    it_should_behave_like "post pages"

  end


end