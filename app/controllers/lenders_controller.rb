class LendersController < ApplicationController
  
  layout 'public'
  
  before_filter :set_tracking
  
  def index
	  @lenders = Lender.not_lender_type("match").by_top_rank
    @page = "0001" #sets page for tracking to 'payday-loans-main'
  end

  def installment
    @lenders = Lender.not_lender_type("match").by_top_rank
    @page = "0004" #sets page for tracking to 'installment-loans'
  end
  	
  def lenders
    if !params.has_key?(:state) then
      redirect_to :action => 'index'
    else  
    #instantiate a new lender and set criteria
    @criteria = Lender.new                            #@criteria gets used on lenders.html
    @criteria.sniff_id = params[:lender][:sniff_id]
    @criteria.ranking = params[:lender][:ranking]

    if params[:lender][:lender_type] == "term"
      @criteria.lender_type = "term"                  #show the term lenders
      @state = TermState.find(params[:state][:id])    
      @page = "0003"                                  #sets page for tracking to 'term-loans-page'
    else
      @criteria.lender_type = "payday"                #show payday even if someone puts into params random term
      @state = State.find(params[:state][:id])
      @page = "0002"                                  #sets page for tracking to 'payday-loans-page'
    end
 
      @select_lenders = @state.lenders
      @lenders = @select_lenders.by_top_rank.sniff_level(@criteria.sniff_id).rank_level(@criteria.ranking)

    end  
  end

end