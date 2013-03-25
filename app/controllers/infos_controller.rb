class InfosController < ApplicationController
 	
	layout 'paydayAppNav'
	
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

  def contact
  end

  def privacy
  end

  def terms
  end

  def why
  end

  def code
    
  end

end
