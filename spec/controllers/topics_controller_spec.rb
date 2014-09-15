require 'spec_helper'

describe TopicsController do

	describe "Index" do
		it "redirects" do
			get :index
			response.should redirect_to("/infos/lost/")
		end	
	end	

	describe "Show" do
		it "assigns requested category to @category" do
			topic = FactoryGirl.create(:topic)
			get :show, id: topic.slug
			assigns(:category).should eq(topic)
		end	

		it "renders the #show view" do
			topic = FactoryGirl.create(:topic)
			get :show, id: topic.slug
			response.should render_template :show
		end

		it "redirects to lost puppy if no category exists" do
			get :show, id: "xx"
			response.should redirect_to("/infos/lost/")
		end

		describe "Show Correct Articles" do
			before(:all){
				Article.destroy_all #make sure we have clean count
				Topic.destroy_all

				2.times {FactoryGirl.create(:topic)}
				@correct_topic = Topic.first
				@empty_topic = Topic.last
				3.times do
					article = FactoryGirl.create(:article)
					FactoryGirl.create(:articles_topic, article: article, topic: @correct_topic)
				end
				FactoryGirl.create(:article)				
			}

			it "shows articles with the correct category" do
				get :show, id: @correct_topic.slug
				assigns(:articles).count.should eq(3)
			end

			it "shows no articles with empty category" do
				get :show, id: @empty_topic.slug
				assigns(:articles).count.should eq(0)
			end

		end
		
	end

	after(:all){
		Topic.destroy_all
		Article.destroy_all
		ArticlesTopic.destroy_all
	}	

end
