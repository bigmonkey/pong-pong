class ApplicationController < ActionController::Base

  protect_from_forgery

  protected


  # TRACKING VARIABLES from external (put in URL pointing to PDH)
  # src -- the source of a visitor
  # camp -- the campaign of a visitor. this includes device, country
  # adg -- the ad groub of a visitor. 
  # kw -- the keyword of a visitor. 
  # ad -- the ad of a visitor. creative
  # plc -- the placement of a visitor. website.


  def set_tracking
  	if !params[:src].nil?
      Source.find_by_src_code(params[:src]).nil? ? session[:src]="0000" : session[:src] = params[:src] 
      session[:camp] = params[:camp]
      session[:adgrp] = params[:adg]
      session[:kw] = params[:kw]
      session[:ad] = params[:ad]
      session[:plc] = params[:plc]
    else 
      session[:src] = session[:src]
    end

  end

  def set_secured_constants
    @pur_balance =  500.0 #revolving purchase balance
    @cash_balance = 0.0 #cash balance balance
    @duration = 8.0  #number of months someone keeps the secured car, ad decimal so not integer  
  end
  
  def set_prepaid_constants

    @atm_owner_fee = 2.50 #fee charged by ATM owners

    @direct_dep = false  #true -- has direct depoist. Values: true or false, case doesn't matter
    @wkly_trans = 8  #number of signature transactions
    @wkly_atm_in_net = 1 #number of atm in network cash withdrawels
    @wkly_atm_out_net = 0 #number of atm out of network cash withdrawals 
    @mthly_load =  1000 #average cash loaded to card
    @mthly_loads = 0 #number of loads
    @wkly_atm_inq = 0 #number of atm balance inquiries
    @calls = 0 #live customer service per month 
    @prepaid_duration = 24 #numner of months keeping the card  

    @max_wkly_purchase = 20
    @max_wkly_atm_in_net = 10 #number of atm cash withdrawels
    @max_wkly_atm_out_net = 10 #number of atm cash withdrawels    
    @max_mthly_load = 4000 # total amount of cash loaded onto card
    @max_mthly_loads = 8 #number of loads
    @max_wkly_atm_inq = 10 #number of atm balance inquiries
    @max_calls = 10 #number of calls to customer service per month
    @max_prepaid_duration = 48 #length of ownership

  end

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
      loans = ["payday loans",  # customized in index
              "direct lender payday loans", #customized in index
              "online payday loans",
              "payday loans online"]
      lenders = ["payday loan direct lenders",  #customized in index
              "direct payday lenders online", #customized in index
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

end
