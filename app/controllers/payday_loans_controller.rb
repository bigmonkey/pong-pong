class PaydayLoansController < ApplicationController

  layout 'paydayNav'
  
  before_filter :set_tracking
  

  def index
  	@states=State.all
	  @lenders = PaydayLoan.by_top_rank.active_lender
		@criteria = PaydayLoan.new    #@criteria gets used on view
		@criteria.sniff_id = 3
   	@criteria.ranking = 0

    # for customizing articles for SEO
    set_seo_vars


    @page = "0013" #sets page for tracking to 'payday-loans-main'
  end

	def show
		# is it random or coming from index or paydayfinder
		if State.find_by_state_abbr(params[:id].upcase).nil?
			redirect_to("/payday-loans/")
		else	
			@criteria = PaydayLoan.new    #@criteria gets used on view
			@criteria.sniff_id = !params[:sniff_id].nil? ? params[:sniff_id] : 3
   		@criteria.ranking = !params[:ranking].nil? ? params[:ranking]	: 1	

      # for customizing articles for SEO
      set_seo_vars

    	@state = State.find_by_state_abbr(params[:id].upcase)
    	@paydaylawstate = @state.payday_loan_law
    	@lenders = @state.payday_loans.by_top_rank.sniff_level(@criteria.sniff_id).rank_level(@criteria.ranking).active_lender

    	# defined so the radio button defaults to correct button
    	@lender=PaydayLoan.new      
    	@lender.lender_type="payday"
    	
		end	
	end
end
