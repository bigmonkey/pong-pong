class PaydayLoanLawsController < ApplicationController

  layout 'paydayAppNav'    

  # before_filter :set_tracking

	def index
		@states=State.all
		@selectorPath = "/payday-loan-laws/" #for State Selector Partial
		
	end

	def show
		@state = State.find_by_state_abbr(params[:id].upcase)
		@paydaylawstate=@state.payday_loan_law
		@paydaylawstatedetails = @state.payday_loan_law_detail
	end
end


 