class BannersController < ApplicationController
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
		banner = Banner.find(params[:id])
		banner.size_160x600 = nil
		banner.save
	end

	private	

	# Use strong_parameters for attribute whitelisting
	# Be sure to update your create() and update() controller methods.	

	def banner_params
	  params.require(:banner).permit(:size_160x600, :partner_id)
	end

end
