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

    before {
      visit articles_path
    }

    it { should have_selector('h1')}    
    it_should_behave_like "article pages"

    after(:all){
      Article.destroy_all
    }
  end

  describe "Articles" do
    let(:article) {FactoryGirl.create(:article)}
    before { visit article_path(article.url)}


    # seo title and description should be use
    it { should have_css("meta[name='description'][content='#{article.description}']", visible: false) }
    it { should have_title("#{article.SEO_title} | The Payday Hound")}   

    # author schema
    it { should have_css("div[itemtype='http://schema.org/Article']", visible: false)}
    it { should have_css("span[itemprop='name']", visible: false)}
    it { should have_css("span[itemprop='dateModified']", visible: false)}
    it { should have_css("span[itemprop='datePublished']", visible: false)}

    #content
    it {should have_selector('h1', text: article.title)}
  end


end