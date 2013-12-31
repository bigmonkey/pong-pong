class PartnersController < ApplicationController
  layout 'partner'

  # removed before filer set_tracking. Don't need tracking on partner.

  def get_url
    l = Partner.find(params[:id])
    if l.lender_tail.blank?
      @lender_url = l.lender_link
    else
      @lender_url = l.lender_link + l.lender_tail + @page + @source 
    end
  end  


  def redirect_values
    #See if the page code is known if not assign it unknown
    #assign unknown page if no page param sent in
    params[:page]="0000" if params[:page].nil?
    if Page.find_by_page_code(params[:page])
        @page = params[:page]
    else
        @page = "0000"
    end
    #See if the source is known if not assign it unknown
    #assign unknown source if no src sent in
    session[:src]="0000" if session[:src].nil? 
    if Source.find_by_src_code(session[:src][0,4])
        @source = session[:src]
    else
        @source = "0000"
    end
    get_url
    @lender_url
    #@lenders = Partner.all
  end

  def show
  	#If there is an ID go to lender app else return to the hound
  	if params[:id].nil?
  		redirect_to("/")
  	else
	  redirect_values
    end
  end


end
