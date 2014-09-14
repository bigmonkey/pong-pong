require 'spec_helper'

describe "Topics" do
	subject { page }

    before(:all) {
      3.times { FactoryGirl.create(:topic) }
      @topics = Topic.all
      @correct_topic = Topic.first
      7.times do
        article = FactoryGirl.create(:article)
        FactoryGirl.create(:articles_topic, article: article, topic: @correct_topic)
      end
      7.times {FactoryGirl.create(:article)}
      @recent_articles = Article.created.first(10)
    }  
    after(:all) {
      Article.destroy_all
      Topic.destroy_all
    }

  shared_examples_for "topic pages" do

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


  describe "Topics" do
    
    before { 
      visit topic_path(@correct_topic.slug)
      #puts page.body
    }

    # seo title and description should be use
    it { should have_css("meta[name='description'][content='Save money. Make smart decisions. Catch up on #{@correct_topic.topic} and protect yourself while saving money.']", visible: false) }
    it { should have_title("Articles for #{@correct_topic.topic} | The Payday Hound")}   

    describe "Pagination" do
      # nav tag is created by kaminari gem
      it { should have_selector('nav.pagination') }

      it "should list each article" do
        @correct_topic.articles.created.page(1).per(5).each do |article|
          page.should have_selector('h1',text: article.title)
          page.should have_content(article.updated_at.strftime("%B %d, %Y"))
          page.should have_content(article.article)   
        end
      end
    end
    #content
    it {should have_selector('h1', text: "Articles for #{@correct_topic.topic}")}
    it_should_behave_like "topic pages"

  end


end