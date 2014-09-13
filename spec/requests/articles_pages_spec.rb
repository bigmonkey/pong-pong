require 'spec_helper'

describe "Articles" do
	subject { page }

  shared_examples_for "article pages" do

    it { should have_css("meta[name='description']", visible: false) }
    it { should have_css("title", visible:false)}

    # sidebar
    it { should have_link('Pre-Approved Lenders', href:"/why-use-the-payday-hound/") }
    # Nav Bar
    it { should have_link('Learn', href:'#')}
    # check for footer
    it { should have_link('About Us', href:"/why-use-the-payday-hound/")}

  end

  describe "Index" do

    let(:article) { FactoryGirl.create(:article) }
  
    before {
      visit articles_path
      #puts page.body
    }

    it { should have_selector('h1')}    
    it_should_behave_like "article pages"

    describe "pagination" do
      before(:all) { 35.times { FactoryGirl.create(:article) } }
      after(:all)  { User.destroy_all }

      it { should have_selector('div.pagination') }

      it "should list each article" do
        Article.paginate(page: 1, per_page: 5).each do |article|
          page.should have_selector('h1',text: article.title)
          page.should have_content(article.updated_at.strftime("%B %d, %Y"))
          page.should have_content(article.article)          
        end
      end
    end

  end

  describe "Articles" do
    let(:article) {FactoryGirl.create(:article)}
    before { visit article_path(article.url)}


    # seo title and description should be use
    it { should have_css("meta[name='description'][content='#{article.description}']", visible: false) }
    it { should have_title("#{article.seo_title} | The Payday Hound")}   

    # author schema
    it { should have_css("div[itemtype='http://schema.org/Article']", visible: false)}
    it { should have_css("span[itemprop='name']", visible: false)}
    it { should have_css("span[itemprop='dateModified']", visible: false)}
    it { should have_css("span[itemprop='datePublished']", visible: false)}

    #content
    it {should have_selector('h1', text: article.title)}
  end


end