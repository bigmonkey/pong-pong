class ApplicantsController < ApplicationController

  layout 'homeNav'
  
  before_filter :set_tracking

  def index
  	@requested_amount=300
  end

end
