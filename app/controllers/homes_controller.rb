class HomesController < ApplicationController
  layout 'homeNav'    

  before_filter :set_tracking
  	
  def index

  end

# Following three methods are called from within Wordpress installation to
# bring in styles, footer and header to the Learn section.
  def jstyle
  	render :partial => "shared/layouts/jstyle"  	
  end

  def header
  	render :partial => "shared/layouts/header"  	
  end

  def footer 
  	render :partial => "shared/layouts/footer"
  end

end