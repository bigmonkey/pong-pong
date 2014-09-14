require 'spec_helper'

describe "Articles" do
	subject { page }

    before(:all) {
      16.times { FactoryGirl.create(:article) }
      @recent_articles = Article.created.first(10)
      3.times { FactoryGirl.create(:topic) }
      @topics = Topic.all
    }  

    after(:all) {
      Article.destroy_all
      Topic.destroy_all
    }

  shared_examples_for "article pages" do

    it { should have_css("meta[name='description']", visible: false) }
    it { should have_css("title", visible:false)}

    # sidebar
    it { should have_selector('h2', text:"Learn") }
    it "should list first category" do
      page.should have_link(@topics.first.topic, href:"/learn/category/#{@topics.first.slug}/")
    end

    it { should have_selector('h2', text:"Recent Posts") }
    it "should list the 2nd most recent article" do
      page.should have_link(@recent_articles[1].title, href:"/learn/#{@recent_articles[1].slug}/")
    end
    # Nav Bar
    it { should have_link('Learn', href:'#')}
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}

  end

  describe "Index" do

    before {
      visit articles_path
      #puts page.body
    }

    it { should have_selector('h1')}    

    describe "Pagination" do
      # nav tag is created by kaminari gem
      it { should have_selector('nav.pagination') }

      it "should list each article" do
        Article.created.page(1).per(5).each do |article|
          page.should have_selector('h1',text: article.title)
          page.should have_content(article.updated_at.strftime("%B %d, %Y"))
          page.should have_content(article.article)   
        end
      end
    end

    it_should_behave_like "article pages"

  end

  describe "Articles" do
    
    before { 
      @current_article = Article.find(2)
      visit article_path(@current_article.slug)
      #puts page.body
    }

    # seo title and description should be use
    it { should have_css("meta[name='description'][content='#{@current_article.description}']", visible: false) }
    it { should have_title("#{@current_article.seo_title} | The Payday Hound")}   

    # author schema
    it { should have_css("div[itemtype='http://schema.org/Article']", visible: false)}
    it { should have_css("span[itemprop='name']", visible: false)}
    it { should have_css("span[itemprop='dateModified']", visible: false)}
    it { should have_css("span[itemprop='datePublished']", visible: false)}

    #content
    it {should have_selector('h1', text: @current_article.title)}
    it_should_behave_like "article pages"

  end


end