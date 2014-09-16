require 'spec_helper'

describe PostsController do
	describe "Index" do
		it "renders the :index view" do
			get :index
			response.should render_template :index
		end	
	end

	describe "Show" do
		it "assigns requested post to @post" do
			post = FactoryGirl.create(:post)
			get :show, id: post.slug
			assigns(:post).should eq(post)
		end	

		it "renders the #show view" do
			post = FactoryGirl.create(:post)
			get :show, id: post.slug
			response.should render_template :show
		end
		
		it "renders the puppy lost page if parameter doesn't exist" do
			get :show, id: "xx"
			response.should redirect_to("/infos/lost/")
		end		
	end

  it_should_behave_like "all controllers that set tracking"

  after(:all){Post.destroy_all}
end
