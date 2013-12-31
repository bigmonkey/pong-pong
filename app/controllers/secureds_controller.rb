class SecuredsController < ApplicationController
  
  layout 'paydayNav'
  
  before_filter :set_tracking
  before_filter :set_secured_constants

  def index
      # set maximum and minimum usage criteria for variable checks
      # need to change public.js slider settings as well in six places.
      # then need to update blog settings and any files that point to public.js, i.e. on resources.pdh.com
      max_balance = 1000
      max_duration = 36
      duration_range = (1..max_duration)
      pur_balance_range = (0..max_balance)
      cash_balance_range = (0..max_balance)

      # if params hold different criteria reset criteria
      if !params[:criteria].nil? then # do params exist
        if (params[:criteria][:PurBal].is_a? String) && (params[:criteria][:CashBal].is_a? String) && (params[:criteria][:Duration].is_a? String) then # are the params strings, i.e. will to_i work
          if pur_balance_range === params[:criteria][:PurBal].to_i && cash_balance_range === params[:criteria][:CashBal].to_i && duration_range === params[:criteria][:Duration].to_i then  # check that numbers are in range
      		  @pur_balance = params[:criteria][:PurBal].to_i
        		@cash_balance = params[:criteria][:CashBal].to_i
        		@duration = params[:criteria][:Duration].to_i
      	  end
        end
      end  
      @secureds = Secured.live.by_top_rank    
  end

  def show
    # get entire list of active secured cards
    @secureds = Secured.live 
    # find record for the specific secured card
    @secured = Secured.find_by_review_url(params[:id])
  end
end
