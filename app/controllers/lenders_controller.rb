class LendersController < ApplicationController
  #lender pages are called form WP in production
  #comment out when going to production so show pages called without layout
  layout 'paydayNav'
  #layout 'lenders'   
  
  before_filter :set_tracking
  
  def index
    redirect_to("#{BASE_DOMAIN}/")
  end

  def finder
    @state=State.find(params[:state][:id]).state_abbr.downcase
    if params[:lender_type] == "term" #send to term loans controller
     redirect_to("#{BASE_DOMAIN}/installment-loans/#{@state}?sniff_score=#{params[:sniff_score]}&ranking=#{params[:ranking]}")
    else          # send to payday loans controller
     redirect_to("#{BASE_DOMAIN}/payday-loans/#{@state}?sniff_score=#{params[:sniff_score]}&ranking=#{params[:ranking]}")
    end  
  end

  def show

    #comes lender pages params[:type] will be filled out
    @lender = nil
    if ["payday","term"].include?(params[:type])
      if params[:type]=="payday"
        @lender=PaydayLoan.find_by_review_url(params[:id])
      else  
        @lender=TermLoan.find_by_review_url(params[:id])
      end
    else
      if !TermLoan.find_by_review_url(params[:id]).nil?
        @lender=TermLoan.find_by_review_url(params[:id])
      else !PaydayLoan.find_by_review_url(params[:id]).nil?
        @lender=PaydayLoan.find_by_review_url(params[:id])
      end  
    end
    # for unpaid lenders need @states and @path for loanfinder
    if !@lender.nil? && !@lender.paid
      @states=State.all
      if @lender.lender_type == "term"
        @path = "installment-loans"
      else
        @path = "payday-loans"
      end  
    end
  end
end