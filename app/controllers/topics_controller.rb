class TopicsController < ApplicationController

	layout 'paydayNav'

	before_filter :set_tracking
	
	def index
		redirect_to articles_path, status:  301
	end

	def show
		category = []
		Topic.all.each do |t|
			category.push(t.slug)
		end
		if !category.include?(params[:id])
			redirect_to articles_path, status: 301
		else
			@category = Topic.find_by_slug(params[:id])
			@articles = @category.articles.created.page(params[:page]).per(5)
			# needed for sidebar
			@recent_articles = Article.created.first(10)
			@categories = Topic.disp_order			
		end	
	end

end
