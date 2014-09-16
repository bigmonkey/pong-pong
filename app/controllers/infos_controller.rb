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

  def lost
    @posts = Post.created.first(15)
    # needed for sidebar
    @recent_posts = Post.created.first(10)
    @categories = Topic.disp_order
  end

end
