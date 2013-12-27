class TermLoansController < ApplicationController
  
  layout 'paydayNav'
  
  before_filter :set_tracking
  

  def index
  	@states=State.all
	  @lenders = TermLoan.by_top_rank.by_low_cost.active_lender
		@criteria = TermLoan.new    #@criteria gets used on view
		@criteria.sniff_id = Sniff.find_by_sniff_score(3).id
   	@criteria.ranking = 0	

    # in application_controller
    set_seo_vars
    
  end

	def show
		# is it random or coming from index or paydayfinder
		if State.find_by_state_abbr(params[:id].upcase).nil?
			redirect_to("/installment-loans/")
		else	
			@criteria = TermLoan.new    #@criteria gets used on view
			@criteria.sniff_id = !params[:sniff_score].nil? ? Sniff.find_by_sniff_score(params[:sniff_score]).id : Sniff.find_by_sniff_score(3).id
   		@criteria.ranking = !params[:ranking].nil?	? params[:ranking] : 1
    	
      # in application_controller
      set_seo_vars 

    	@state = State.find_by_state_abbr(params[:id].upcase)
    	@paydaylawstate = @state.payday_loan_law
    	@lenders = @state.term_loans.by_top_rank.sniff_level(@criteria.sniff.sniff_score).rank_level(@criteria.ranking).active_lender

    	# defined so the radio button defaults to correct button
    	@lender=TermLoan.new      
    	@lender.lender_type="term"
    	
		end	
	end  
end

