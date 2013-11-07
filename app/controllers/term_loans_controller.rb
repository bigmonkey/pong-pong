class TermLoansController < ApplicationController
  layout 'paydayNav'
  
  before_filter :set_tracking
  
  def set_seo_vars(src)
      # for customizing articles for SEO
      
      if src == "index"
        @selectorPath =  request.fullpath[0..-1] #used for linking takes whole string
      else
        @selectorPath =  request.fullpath[0..-4] #used for linking drops state abbr
      end    
      @keyWord = @selectorPath.gsub('-',' ')[1..-1] #pulls out kw from url and drop first slash
      # categorize kw's into loans or lenders. copy is different for the two
      # copy assyme kw's are plural, i.e. loanS and lenderS
      # add kw's to routing
      loans = ["installment loans", 
              "short term installment loans",
              "installment loans online"]
      lenders = ["online installment loan direct lenders",
              "installment loan lenders",
              "bad credit installment loan direct lenders",
              "direct installment loan lenders"]        
      case @keyWord
        when *loans
          @keyWordType = "loans"
        when *lenders  
          @keyWordType = "lenders"
        else #if something is routed but mistakenly not added to kw list above
          @keyWordType = "loans"
          @keyWord = "installment loans"  
      end   
  end


  def index
  	@states=State.all
	  @lenders = TermLoan.by_top_rank.by_low_cost.active_lender
		@criteria = TermLoan.new    #@criteria gets used on view
		@criteria.sniff_id = 3
   	@criteria.ranking = 0	

    set_seo_vars("index")
    
  end

	def show
		# is it random or coming from index or paydayfinder
		if State.find_by_state_abbr(params[:id].upcase).nil?
			redirect_to("/installment-loans/")
		else	
			@criteria = TermLoan.new    #@criteria gets used on view
			@criteria.sniff_id = !params[:sniff_id].nil? ? params[:sniff_id] : 3
   		@criteria.ranking = !params[:ranking].nil?	? params[:ranking] : 1
    	
      set_seo_vars("state")

    	@state = State.find_by_state_abbr(params[:id].upcase)
    	@paydaylawstate = @state.payday_loan_law
    	@lenders = @state.term_loans.by_top_rank.sniff_level(@criteria.sniff_id).rank_level(@criteria.ranking).active_lender

    	# defined so the radio button defaults to correct button
    	@lender=TermLoan.new      
    	@lender.lender_type="term"
    	
		end	
	end  
end

