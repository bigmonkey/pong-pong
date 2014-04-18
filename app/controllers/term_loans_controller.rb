class TermLoansController < ApplicationController
  
  layout 'paydayNav'
  
  before_filter :set_tracking
  

  def index
    # in application_controller
    set_seo_vars
    @path = request.path.split(/\//)[1]
    # params[:state] must come in as Upcase otherwise styles get mixed up because
    # form will set id to state_id for Idaho and that conflicts with 
    # select form on _shared/paydayfinder
    redirect_to "#{BASE_DOMAIN}/#{@path}/#{params[:state].downcase}/" if !params[:state].blank?

  	@states=State.all
    if @keyword.word.match('military')
      then @lenders = TermLoan.by_top_rank.by_low_cost.active_lender
      else @lenders = TermLoan.lender_type('term').by_top_rank.by_low_cost.active_lender
    end
		@criteria = TermLoan.new    #@criteria gets used on view
		@criteria.sniff_id = Sniff.find_by_sniff_score(3).id
   	@criteria.ranking = 0	

  end

	def show
    # in application_controller
    set_seo_vars 

    # creates array @offered_states of states where 'lender' makes loans. Used to display ads 
    offered_states(TermLoan.find_by_name('Net Credit'))

		# is it random or coming from index or paydayfinder
		if State.find_by_state_abbr(params[:id].upcase).nil?
			redirect_to("#{BASE_DOMAIN}/installment-loans/")
		else	
      # paid_lenders is in application_controller
      # creates array of lender id's who offer loans in this state
      # format is paid_lenders(<'payday' 'term' 'advertiser'>, params[:id].upcase)

      paid_lenders('term', params[:id].upcase)

			@criteria = TermLoan.new    #@criteria gets used on view
			@criteria.sniff_id = !params[:sniff_score].blank? ? Sniff.find_by_sniff_score(params[:sniff_score]).id : Sniff.find_by_sniff_score(3).id
   		@criteria.ranking = !params[:ranking].blank?	? params[:ranking] : 1
    	@state = State.find_by_state_abbr(params[:id].upcase)
    	@paydaylawstate = @state.payday_loan_law
      if @keyword.word.match('military')
        then @lenders = @state.term_loans.by_top_rank.sniff_level(@criteria.sniff.sniff_score).rank_level(@criteria.ranking).active_lender
        else @lenders = @state.term_loans.lender_type('term').by_top_rank.sniff_level(@criteria.sniff.sniff_score).rank_level(@criteria.ranking).active_lender  
      end      

    	# defined so the radio button defaults to correct button
    	@lender=TermLoan.new      
    	@lender.lender_type="term"
    	
		end	
	end  
end

