class BannersController < ApplicationController
  before_filter :authenticate_user!		
	layout 'nopublic'	

	def index
		@banners = Banner.all
	end	

	def show
		@banner = Banner.find(params[:id])
	end	

	def new
		@banner = Banner.new
	end	

	def create
		#binding.pry
	  @banner = Banner.create( banner_params )
	end	

	def destroy
		Banner.find(params[:id]).destroy
	end

	private	

	# Use strong_parameters for attribute whitelisting
	# Be sure to update your create() and update() controller methods.	

	def banner_params
	  params.require(:banner).permit(:size_160x600, :partner_id)
	end

end
