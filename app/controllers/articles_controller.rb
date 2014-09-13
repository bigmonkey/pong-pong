class ArticlesController < ApplicationController

	layout 'paydayNav'

	before_filter :set_tracking
	
	def index
		@articles = Article.paginate(page: params[:page], per_page: 5) 
	end
	
	def show
		@article = Article.find_by_url(params[:id])
	end

end
