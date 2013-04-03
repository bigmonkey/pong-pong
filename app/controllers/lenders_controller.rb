class LendersController < ApplicationController
  
  layout 'paydayAppNav'
  
  before_filter :set_tracking
  
  def index
    redirect_to("http://www.thepaydayhound.com/payday-loans/")
  end

  def finder
    @state=State.find(params[:state][:id]).state_abbr.downcase
    if params[:lender][:lender_type] == "term" #send to term loans controller
     redirect_to("http://www.thepaydayhound.com/installment-loans/#{@state}?lender[sniff_id]=#{params[:lender][:sniff_id]}&lender[ranking]=#{params[:lender][:ranking]}")
    else          # send to payday loans controller
     redirect_to("http://www.thepaydayhound.com/payday-loans/#{@state}?lender[sniff_id]=#{params[:lender][:sniff_id]}&lender[ranking]=#{params[:lender][:ranking]}")
    end  
  end

  def show
    
    
  end
end