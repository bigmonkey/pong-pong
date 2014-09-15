class TopicsController < ApplicationController

	layout 'paydayNav'

	before_filter :set_tracking
	
	def index
		redirect_to articles_path, status:  301
	end

	def show
		# the find_by_slug! returns Record Not found if nothing exits. This is escaped to the root using rescue_from in the application controller at the top and the private method it directs to
		if @category = Topic.find_by_slug!(params[:id])
			@articles = @category.articles.created.page(params[:page]).per(5)
			# needed for sidebar
			@recent_articles = Article.created.first(10)
			@categories = Topic.disp_order			
		end	
	end

end
