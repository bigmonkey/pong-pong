class PaydayLoanLawsController < ApplicationController

  layout 'paydayNav'    

  before_filter :set_tracking

	def index
		@states=State.all
		@selector_path = request.fullpath #for State Selector Partial
		
	end

	def show
		if State.find_by_state_abbr(params[:id].upcase).nil?
			then redirect_to payday_loan_laws_path
			else
				@state = State.find_by_state_abbr(params[:id].upcase)
				@paydaylawstate=@state.payday_loan_law
				@paydaylawstatedetails = @state.payday_loan_law_detail
		end
	end
end


 