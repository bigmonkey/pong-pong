class TopicsController < ApplicationController

	layout 'paydayNav'

	before_filter :set_tracking
	
	def index
		redirect_to("/infos/lost/")
	end

	def show
		# the find_by_slug! returns Record Not Found if nothing exits. This is escaped in the applications_controller via the rescue_from at top and method it directs to below
		if @category = Topic.find_by_slug!(params[:id])
			@posts = @category.posts.created.page(params[:page]).per(5)
			# needed for sidebar
			@recent_posts = Post.created.first(10)
			@categories = Topic.disp_order			
		end	
	end

end
