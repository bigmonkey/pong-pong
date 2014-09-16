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

		describe "Show Correct Posts" do
			before(:all){
				Post.destroy_all #make sure we have clean count
				Topic.destroy_all

				2.times {FactoryGirl.create(:topic)}
				@correct_topic = Topic.first
				@empty_topic = Topic.last
				3.times do
					post = FactoryGirl.create(:post)
					FactoryGirl.create(:posts_topic, post: post, topic: @correct_topic)
				end
				FactoryGirl.create(:post)				
			}

			it "shows posts with the correct category" do
				get :show, id: @correct_topic.slug
				assigns(:posts).count.should eq(3)
			end

			it "shows no posts with empty category" do
				get :show, id: @empty_topic.slug
				assigns(:posts).count.should eq(0)
			end

		end
		
	end

	after(:all){
		Topic.destroy_all
		Post.destroy_all
		PostsTopic.destroy_all
	}	

end
