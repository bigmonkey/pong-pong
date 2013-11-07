class PaydayLoansController < ApplicationController

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
      loans = ["payday loans", 
              "online payday loans",
              "payday loans online",
              "direct lender payday loans"]
      lenders = ["payday loan direct lenders",
              "direct payday lenders online",
              "payday lenders",
              "direct lenders for payday loans",
              "direct online payday lenders"]        
      case @keyWord
        when *loans
          @keyWordType = "loans"
        when *lenders  
          @keyWordType = "lenders"
        else #if something is routed but mistakenly not added to kw list above
          @keyWordType = "loans"
          @keyWord = "payday loans"  
      end   
  end

  def index
  	@states=State.all
	  @lenders = PaydayLoan.by_top_rank.active_lender
		@criteria = PaydayLoan.new    #@criteria gets used on view
		@criteria.sniff_id = 3
   	@criteria.ranking = 0

    # for customizing articles for SEO
    set_seo_vars("index")


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
      set_seo_vars("state")

    	@state = State.find_by_state_abbr(params[:id].upcase)
    	@paydaylawstate = @state.payday_loan_law
    	@lenders = @state.payday_loans.by_top_rank.sniff_level(@criteria.sniff_id).rank_level(@criteria.ranking).active_lender

    	# defined so the radio button defaults to correct button
    	@lender=PaydayLoan.new      
    	@lender.lender_type="payday"
    	
		end	
	end
end
