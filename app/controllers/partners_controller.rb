class PartnersController < ApplicationController
  layout 'partner'

  # removed before filer set_tracking. Don't need tracking on partner.

  def show
  	#If there is an ID go to lender website else return to the hound
  	if params[:id].blank? || Partner.find_by_id(params[:id]).nil?
  		redirect_to("/")
  	else
      if !request.env["HTTP_REFERER"].blank?
        uri = URI(request.env["HTTP_REFERER"])
        # use session for :exit_page because loan application assigns it as page that leads to prequal page or two states ahead
        session[:exit_page] = uri.path + (!uri.query.nil? ? "?#{uri.query}" : "")
      end
      #@partner is instance variable bc it's used the view for Taboola tracking pixel
      @partner = Partner.find(params[:id])
      @redirect=@partner.name
      save_tracking
      if @partner.lender_tail.blank?
        @lender_url = @partner.lender_link
      else
        @lender_url = @partner.lender_link + @partner.lender_tail + session[:token]
      end
      # paid_partner(id) method defined in application controller.
      # returns true for paid partnes. @paid_partner used for tracking pixel
      @paid_partner = paid_partner(@partner.id)
    end
  end


end
