class TopoffersController < ApplicationController

  layout 'lp'
  
  before_filter :set_tracking

  def index
  	render ('prepaid')
  end	

	def badcredit
  	@page="0012"
  end

  def prepaid
  	@page="0010"
  end
  	
  def prepaid_b
    @page="0013"
  end


end
