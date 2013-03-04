class HomesController < ApplicationController
  layout 'public'    

  before_filter :set_tracking
  	
  def index
  end

  def wrapper
  	render :partial => "shared/layouts/wrapper"
  end

end