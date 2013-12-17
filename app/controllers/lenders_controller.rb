class LendersController < ApplicationController
  #lender pages are called form WP in production
  #comment out when going to production so show pages called without layout
  #layout 'paydayNav'
  
  before_filter :set_tracking
  
  def index
    redirect_to("http://www.thepaydayhound.com/payday-loans/")
  end

  def finder
    @state=State.find(params[:state][:id]).state_abbr.downcase
    if params[:lender_type] == "term" #send to term loans controller
     redirect_to("http://www.thepaydayhound.com/installment-loans/#{@state}?sniff_id=#{params[:sniff_id]}&ranking=#{params[:ranking]}")
    else          # send to payday loans controller
     redirect_to("http://www.thepaydayhound.com/payday-loans/#{@state}?sniff_id=#{params[:sniff_id]}&ranking=#{params[:ranking]}")
    end  
  end

  def show
    @lender = nil
    if !params[:id].nil?
      if !PaydayLoan.find_by_review_url(params[:id]).nil?
        @lender=PaydayLoan.find_by_review_url(params[:id])
      else !TermLoan.find_by_review_url(params[:id]).nil?
        @lender=TermLoan.find_by_review_url(params[:id])
      end
    end      
  end
end