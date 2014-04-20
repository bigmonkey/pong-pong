class PaydayLoanLawsController < ApplicationController

  layout 'paydayNav'    

  before_filter :set_tracking

	def index
		@states=State.all
		@selector_path = request.fullpath #for State Selector Partial
    @path = request.path.split(/\//)[1]		
	  redirect_to "#{BASE_DOMAIN}/payday-loans/#{params[:state].downcase}/" if !params[:state].blank?

		
	end

	def show
		if State.find_by_state_abbr(params[:id].upcase).nil?
			then redirect_to("#{BASE_DOMAIN}/payday-loans-laws/")
			else
				@state = State.find_by_state_abbr(params[:id].upcase)
				@paydaylawstate=@state.payday_loan_law
				@paydaylawstatedetails = @state.payday_loan_law_detail

	      # paid_lenders is in application_controller
	      # creates array of lender id's who offer loans in this state
	      # it is used to display the top lenders intro boxes on each page
	      # format is paid_lenders(<'payday' 'term' 'advertiser'>, params[:id].upcase)
	      paid_lenders('payday', params[:id].upcase)				

	      # paid_banners is in application controller
	      # selects a banner from lenders offering loans in this state
	      paid_banner(params[:id])

      	@keyword = Keyword.find_by_word('payday loans') 
		end
	end
end


 