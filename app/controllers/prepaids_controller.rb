class PrepaidsController < ApplicationController

  layout 'paydayNav'
  
  before_filter :set_tracking
  before_filter :set_prepaid_constants

  def index
      # set maximum and minimum usage criteria for variable checks
      # need to change public.js slider settings as well in six places.
      # then need to update blog settings and any files that point to public.js, i.e. on resources.pdh.com

      wkly_trans_range = (0..@max_wkly_purchase)
      wkly_atm_in_net_range = (0..@max_wkly_atm_in_net)
      wkly_atm_out_net_range = (0..@max_wkly_atm_out_net)
      mthly_load_range = (0..@max_mthly_load)
      mthly_loads_range = (0..@max_mthly_loads)
      wkly_atm_inq_range = (0..@max_wkly_atm_inq)
      calls_range = (0..@max_calls)
      prepaid_duration_range = (1..@max_prepaid_duration)


      # if params hold different criteria reset criteria
      if !params[:criteria].nil? # do params exist
      then if  # are the params strings, i.e. will to_i work
            (params[:criteria][:CalcDirectDep].is_a? String) && 
            (params[:criteria][:CalcWklyTrans].is_a? String) && 
            (params[:criteria][:CalcATMIn].is_a? String) && 
            (params[:criteria][:CalcATMOut].is_a? String) && 
            (params[:criteria][:CalcMthlyLoad].is_a? String) && 
            (params[:criteria][:CalcMthlyLoads].is_a? String) && 
            (params[:criteria][:CalcATMInq].is_a? String) && 
            (params[:criteria][:CalcCalls].is_a? String) && 
            (params[:criteria][:CalcPrepaidDur].is_a? String) 
            then if  # check that numbers are in range. attends: @direct_dep is handled different
              wkly_trans_range === params[:criteria][:CalcWklyTrans].to_i && 
              wkly_atm_in_net_range === params[:criteria][:CalcATMIn].to_i &&
              wkly_atm_out_net_range === params[:criteria][:CalcATMOut].to_i && 
              mthly_load_range === params[:criteria][:CalcMthlyLoad].to_i && 
              mthly_loads_range === params[:criteria][:CalcMthlyLoads].to_i && 
              wkly_atm_inq_range === params[:criteria][:CalcATMInq].to_i && 
              calls_range === params[:criteria][:CalcCalls].to_i && 
              prepaid_duration_range === params[:criteria][:CalcPrepaidDur].to_i 
              then #assign them the params values   
                (@direct_dep = true) if (params[:criteria][:CalcDirectDep] == "true")
                @wkly_trans = params[:criteria][:CalcWklyTrans].to_i
                @wkly_atm_in_net = params[:criteria][:CalcATMIn].to_i
                @wkly_atm_out_net = params[:criteria][:CalcATMOut].to_i
                @mthly_load = params[:criteria][:CalcMthlyLoad].to_i 
                @mthly_loads = params[:criteria][:CalcMthlyLoads].to_i 
                @wkly_atm_inq = params[:criteria][:CalcATMInq].to_i 
                @calls = params[:criteria][:CalcCalls].to_i 
                @prepaid_duration = params[:criteria][:CalcPrepaidDur].to_i
          	  end
            end
      end  
      @prepaids = Prepaid.live     
  	  @page = "0008" #sets page for tracking to 'pre-paid-cards'
  end

  def show
    # get entire list of active cards
    @prepaids = Prepaid.live 
    # get record for specific card
    @prepaid = Prepaid.find_by_review_url(params[:id])
  end
end
