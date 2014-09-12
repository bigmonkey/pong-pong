class ArticlesController < ApplicationController

	layout 'paydayNav'

	before_filter :set_tracking
	
	def index
	end
	
	def show
		@article = Article.find_by_url(params[:id])
	end

end
