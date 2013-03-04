class ApplicantsController < ApplicationController

  layout 'public'
  
  before_filter :set_tracking

  def index
  	@requested_amount=300
  end

end
