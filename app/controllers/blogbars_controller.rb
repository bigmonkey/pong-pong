class BlogbarsController < ApplicationController

  layout 'nopublic'

  before_filter :set_secured_constants
  before_filter :set_prepaid_constants

  def payday
      @lender=PaydayLoan.new      
      @lender.lender_type="payday" 	
  end

  def prepaid
  	
  end

  def secured
  	
  end

end
