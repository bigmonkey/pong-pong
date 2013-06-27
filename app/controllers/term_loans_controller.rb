class TermLoansController < ApplicationController
  layout 'paydayNav'
  
  before_filter :set_tracking
  
  def index
  	@selectorPath = "/installment-loans/" #for State Selector Partial
  	@states=State.all
	  @lenders = TermLoan.by_top_rank.by_low_cost
		@criteria = TermLoan.new    #@criteria gets used on view
		@criteria.sniff_id = 3
   	@criteria.ranking = 0	
  	@page = "0014" #sets page for tracking to 'payday-loans-main'
  end

	def show
		# is it random or coming from index or paydayfinder
		if State.find_by_state_abbr(params[:id].upcase).nil?
			redirect_to("/installment-loans/")
		else	
			@criteria = TermLoan.new    #@criteria gets used on view
			@criteria.sniff_id = !params[:sniff_id].nil? ? params[:sniff_id] : 3
   		@criteria.ranking = !params[:ranking].nil?	? params[:ranking] : 1
    	

    	@state = State.find_by_state_abbr(params[:id].upcase)
    	@paydaylawstate = @state.payday_loan_law
    	@lenders = @state.term_loans.by_top_rank.sniff_level(@criteria.sniff_id).rank_level(@criteria.ranking)

    	# defined so the radio button defaults to correct button
    	@lender=TermLoan.new      
    	@lender.lender_type="term"
    	
		end	
	end  
end

