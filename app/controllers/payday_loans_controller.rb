class PaydayLoansController < ApplicationController

  layout 'paydayAppNav'
  
  before_filter :set_tracking
  
  def index
  	@selectorPath = "/payday-loans/" #for State Selector Partial
  	@states=State.all
	  @lenders = PaydayLoan.by_top_rank
		@criteria = PaydayLoan.new    #@criteria gets used on view
		@criteria.sniff_id = 3
   	@criteria.ranking = 0	
    @page = "0013" #sets page for tracking to 'payday-loans-main'
  end

	def show
		# is it random or coming from index or paydayfinder
		if ( !params.has_key?(:lender) && State.find_by_state_abbr(params[:id].upcase).nil?)
			redirect_to("/payday-loans/")
		else	
			@criteria = PaydayLoan.new    #@criteria gets used on view

			# coming from finder
			if params.has_key?(:lender)	 
				@criteria.sniff_id = params[:lender][:sniff_id]
    		@criteria.ranking = params[:lender][:ranking]			
    	
    	# coming from index	
    	else	
				@criteria.sniff_id = 3
	    	@criteria.ranking = 1	
			end

    	@state = State.find_by_state_abbr(params[:id].upcase)
    	@paydaylawstate = @state.payday_loan_law
    	@lenders = @state.payday_loans.by_top_rank.sniff_level(@criteria.sniff_id).rank_level(@criteria.ranking)

    	# defined so the radio button defaults to correct button
    	@lender=Lender.new      
    	@lender.lender_type="payday"
    	
		end	
	end
end
