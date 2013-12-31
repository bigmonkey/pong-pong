class TopoffersController < ApplicationController

  layout 'lp'
  
  before_filter :set_tracking

  def index
  	render ('prepaid')
  end	

	def badcredit

  end

  def prepaid

  end
  	
  def prepaid_b

  end


end
