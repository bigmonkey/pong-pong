class LendersController < ApplicationController
  
  layout 'paydayAppNav'
  
  before_filter :set_tracking
  
  def index
    redirect_to("/payday-loans/")
  end

  def finder
    @state=State.find(params[:state][:id]).state_abbr.downcase
    if params[:lender_type] == "term" #send to term loans controller
     redirect_to("/installment-loans/#{@state}?sniff_id=#{params[:sniff_id]}&ranking=#{params[:ranking]}")
    else          # send to payday loans controller
     redirect_to("/payday-loans/#{@state}?sniff_id=#{params[:sniff_id]}&ranking=#{params[:ranking]}")
    end  
  end

  def show
    
    
  end
end