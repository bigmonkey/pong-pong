class ArticlesController < ApplicationController

	layout 'paydayNav'

	before_filter :set_tracking
	
	def index
		@articles = Article.created.page(params[:page]).per(5) 

		# needed for sidebar
		@recent_articles = Article.created.first(10)
		@categories = Topic.disp_order
	end
	
	def show
		@article = Article.find_by_slug(params[:id])

		# needed for sidebar
		@recent_articles = Article.created.first(10)
		@categories = Topic.disp_order
	end

end
