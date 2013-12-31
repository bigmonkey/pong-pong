class PartnersController < ApplicationController
  layout 'partner'

  # removed before filer set_tracking. Don't need tracking on partner.

  def show
  	#If there is an ID go to lender website else return to the hound
  	if params[:id].blank?
  		redirect_to("/")
  	else
      uri = URI(request.env["HTTP_REFERER"])
      session[:exit_page] = uri.path + (!uri.query.nil? ? "?#{uri.query}" : "")
      p = Partner.find(params[:id])
      session[:redirect]=p.name
      save_tracking
      if p.lender_tail.blank?
        @lender_url = p.lender_link
      else
        @lender_url = p.lender_link + p.lender_tail + session[:token]
      end
    end
  end


end
