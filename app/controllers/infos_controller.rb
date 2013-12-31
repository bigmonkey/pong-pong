class InfosController < ApplicationController
 	
	layout 'homeNav'
	
  before_filter :set_tracking
  
  def index
    about
    render('about')
  end
  def jobs
  end

  def press
  end

  def about
    
  end

  def terms
  end

  def why
  end

  def who
    session[:http_referer] = request.env["HTTP_REFERER"]
    @test = URI(session[:http_referer].to_s)
  end

end
