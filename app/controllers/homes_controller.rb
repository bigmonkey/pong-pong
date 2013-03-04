class HomesController < ApplicationController
  layout 'public'    

  before_filter :set_tracking
  	
  def index
  end

  def wrapper
  	render :partial => "shared/layouts/wrapper"
  end

  def jscodes
  	render :partial => "shared/layouts/jscodes"  	
  end

  def header
  	render :partial => "shared/layouts/header"  	
  end

  def footer 
  	render :partial => "shared/layouts/footer"
  end

end