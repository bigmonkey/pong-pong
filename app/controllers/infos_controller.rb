class InfosController < ApplicationController
 	
  layout 'paydayNav'
	
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
  end

end
