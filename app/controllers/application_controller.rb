class ApplicationController < ActionController::Base
 
  def wp    
    redirect_to ("http://www.thepaydayhound.com/learn" + request.fullpath), :status => 301
  end 

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

  def set_seo_vars
      # for customizing articles for SEO
      # @keyword.category broken into three categories: custom, loans, and lenders. Used for copy choices in index
      # @keyword.controller is used in routes in keyword controller. once here payday or term controller is this
      # @keyword.word seo target kw
      # @keyword.phrase seo target kw in plural phrase. Copy assume plural. Quick Loan becomes Quick Loan Options
      # routing is done in keywords controller

      @keyword = Keyword.find_by_slug(request.fullpath.split(/\//)[1]) #captures stuff between first two slases
      @selector_path = "/"+@keyword.slug #need for state_selector b/c payday_loan_laws uses @selector_path

      # related_kw_links is used to make sure all kw's are hooked into site tree
      # All must be linked back to two major pages: /payday-loans, /installment-loans or /learn
      # for /payday-loans and /installment-loans these pages show up automatically using related_kw_links
      related_keywords = Keyword.where(:parent_page => @keyword.parent_page).pluck(:word) - [].push(@keyword.word)  #pull related kw's remove current kw because don't want list of related kw containing the same kw
      @related_kw_links = []
      related_keywords.each do |word|
        @related_kw_links.push("<a href = \"/#{word.gsub(' ','-')}\">#{word}</a>") #creates links for the related kws
      end  
  end

end
