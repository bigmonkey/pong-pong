class HomesController < ApplicationController
  layout 'public'    

  before_filter :set_tracking
  	
  def index
  	redirect("http://www.thepaydayhound.com")
  end
end