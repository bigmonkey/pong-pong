class PartnersController < ApplicationController
  layout 'partner'

  # removed before filer set_tracking. Don't need tracking on partner.

  def get_url
    l = Partner.find(params[:id])
    if l.lender_tail.blank?
      @lender_url = l.lender_link
    else
      @lender_url = l.lender_link + l.lender_tail + session[:token]
    end
  end  

  def show
  	#If there is an ID go to lender website else return to the hound
  	if params[:id].blank?
  		redirect_to("/")
  	else
      uri = URI(request.env["HTTP_REFERER"])
      session[:exit_page] = uri.path + '?' + (!uri.query.nil? ? uri.query : "")
      save_tracking
      get_url
    end
  end


end
