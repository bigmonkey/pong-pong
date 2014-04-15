class ApplicantsController < ApplicationController

  layout 'paydayNav'
  
  before_filter :set_tracking

  def index
  	@requested_amount=300
    if !request.env["HTTP_REFERER"].blank?
      uri = URI(request.env["HTTP_REFERER"])
      session[:exit_page] = uri.path + (!uri.query.nil? ? "?#{uri.query}" : "")
    end  	
  end

end
