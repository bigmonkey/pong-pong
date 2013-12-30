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
    session[:http_referer] = request.env["HTTP_REFERER"]
  end

  def terms
  end

  def why
  end

  def who
    @test = URI(session[:http_referer].to_s).host
  end

end
