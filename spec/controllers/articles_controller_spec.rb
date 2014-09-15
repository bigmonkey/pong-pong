require 'spec_helper'

describe ArticlesController do

	describe "Index" do
		it "renders the :index view" do
			get :index
			response.should render_template :index
		end	
	end

	describe "Show" do
		it "assigns requested article to @article" do
			article = FactoryGirl.create(:article)
			get :show, id: article.slug
			assigns(:article).should eq(article)
		end	

		it "renders the #show view" do
			article = FactoryGirl.create(:article)
			get :show, id: article.slug
			response.should render_template :show
		end
		
		it "renders the puppy lost page if parameter doesn't exist" do
			get :show, id: "xx"
			response.should redirect_to("/infos/lost/")
		end		
	end

  it_should_behave_like "all controllers that set tracking"

  after(:all){Article.destroy_all}
end
