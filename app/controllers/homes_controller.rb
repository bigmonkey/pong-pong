class HomesController < ApplicationController
  layout 'paydayNav'    

  # before filter is commented out for tracking_pixel use with wordpress
  # tracking for root is done by calling set_tracking in the index action
  # tracking for wordpress uses tracking_pixel method below
  # it sets session cookies based on wordpress calling for an image:
  # <img src="http://www.thepaydayhound.com/tracking_pixel?referer_uri=<?php echo $_SERVER['HTTP_REFERER']; ?>" alt="" width="1" height="1">
  #before_filter :set_tracking
  	
  def index
    set_tracking
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

  def nav
    render :partial => "shared/layouts/nav"
  end

  def loan_drop
    render partial: "shared/loan_drop"
  end

  def site_160x600
    render partial: "shared/ads/g_160x600_sitewide_side"
  end
  
  def tracking_pixel
    if session[:page_views].nil?
      session[:page_views] = 1  
      # coming from wordpress page. HTTP_REFERER is actually the wordpress page so HTTP_REFERER on wordpress page is saved in params and sent in img call 
      session[:referer_uri] = params[:referer_uri]
      session[:device] = set_device
      # entry page is the page call for image
      session[:entry_page] = URI(request.env["HTTP_REFERER"]).path
      session[:entry_time] = Time.now
    else
      session[:page_views] += 1
    end    
    send_data(Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), type: 'image/png', disposition: 'inline')
  end

end