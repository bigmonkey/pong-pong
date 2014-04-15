class PaydayLoansController < ApplicationController

  layout 'paydayNav'
  
  before_filter :set_tracking
  

  def index

    # in application_controller
    set_seo_vars
    
    # params[:state] must come in as Upcase otherwise styles get mixed up because
    # form will set id to state_id for Idaho and that conflicts with 
    # select form on _shared/paydayfinder
    redirect_to action: 'show', id: params[:state].downcase if !params[:state].blank?

  	@states=State.all
	  @lenders = PaydayLoan.by_top_rank.active_lender
		@criteria = PaydayLoan.new    #@criteria gets used on view
		@criteria.sniff_id = Sniff.find_by_sniff_score(3).id
   	@criteria.ranking = 0
    # for customizing articles for SEO


  end

	def show
 
    # creates array @offered_states of states where 'lender' makes loans. Used to display ads 
    offered_states(TermLoan.find_by_name('Net Credit'))

		# is it random or coming from index or paydayfinder
		if (State.find_by_state_abbr(params[:id].upcase).nil?)
			redirect_to("/payday-loans/")
		else	
      # paid_lenders is in application_controller
      # creates array of lender id's who offer loans in this state
      # format is paid_lenders(<'payday' 'term' 'advertiser'>, params[:id].upcase)

      paid_lenders('payday', params[:id].upcase)

			@criteria = PaydayLoan.new    #@criteria gets used on view
			@criteria.sniff_id = !params[:sniff_score].blank? ? Sniff.find_by_sniff_score(params[:sniff_score]).id : Sniff.find_by_sniff_score(3).id
   		@criteria.ranking = !params[:ranking].blank? ? params[:ranking]	: 1	

      # for customizing articles for SEO
      # in application_controller
      set_seo_vars

    	@state = State.find_by_state_abbr(params[:id].upcase)
    	@paydaylawstate = @state.payday_loan_law
    	@lenders = @state.payday_loans.by_top_rank.sniff_level(@criteria.sniff.sniff_score).rank_level(@criteria.ranking).active_lender

    	# defined so the radio button defaults to correct button
    	@lender=PaydayLoan.new      
    	@lender.lender_type="payday"
		end	
	end
end
