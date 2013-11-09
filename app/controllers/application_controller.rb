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

  def get_kws 
      
      # used in set_seo_var
      # KW's ADDED TO THIS LIST must also be added to routes.rb
      # kw's broken into loans and lenders and within each by installment and payday
      # KW REQUIREMENTS
      # -- must have be plural and have either loans or lenders
      # -- must include installment or payday
      # These requirements are because the copy is written for plural and
      # the payday and installment are used to pull out correct kw's when
      # they are listed as other relevant terms. This list occurs on the 
      # index.html for payday_loans and term_loans. The list only shows up
      # for the main four terms: payday loans, installment loans, payday lenders,
      # and installment loan lenders
      # The kw's are listed here for SEO. This is how they enter the site tree
      
      @loan_kws = [ 
            # Term loan terms
              "installment loans",   #customized in index
              "short term installment loans",   #customized in index
              "installment loans online",
              "bad credit installment loans",

            # Payday loans terms
              "payday loans",  # customized in index
              "direct lender payday loans", #customized in index
              "online payday loans",
              "pay day loans online",
              "payday advances", #customized
              "online cash advances" #customized
              ]

      @lender_kws = [
            # Term lenders terms
              "online installment loan direct lenders",  #customized in index
              "installment loan lenders", 
              "bad credit installment loan direct lenders",  #customized in index
              "direct installment loan lenders",

            # Payday lenders terms
              "payday loan direct lenders",  #customized in index
              "direct payday lenders online", #customized in index
              "payday lenders",
              "online payday lenders",
              "direct lenders for payday loans",
              "direct online payday lenders"]  #customized in index
  end
  
  def set_seo_vars(src, srcType)
      # for customizing articles for SEO
      
      if src == "index"
        @selectorPath =  request.fullpath[0..-1] #used for linking takes whole string
      else
        @selectorPath =  request.fullpath[0..-4] #used for linking drops state abbr
      end    
      @keyWord = @selectorPath.gsub('-',' ')[1..-1] #pulls out kw from url and drop first slash

      get_kws  

      # categorizes kw's into loans or lenders. copy is different for the two
      # copy assumes kw's are plural, i.e. loanS and lenderS
      # add kw's to routing, routing directs to term or payday controller
      case @keyWord
        when *@loan_kws
          @keyWordType = "loans"
        when *@lender_kws  
          @keyWordType = "lenders"
        else #if something is routed but mistakenly not added to kw list above
          @keyWordType = "loans"
          @keyWord = (srcType == "term" ? "installment loans" : "payday loans")  
      end   

      # Remove installment loan terms from list for payday loans and vice versa. The
      # same is done for lenders.
      # Pared down list is used in index.html to list other search terms for the main
      # kw's: payday loans, payday lenders, installment loans, and installment lenders
      filter = srcType == "term" ? "installment" : "payday"  #filter to remove payday or installment terms

      # create pared down list for loans
      hold=[] 
      @loan_kws = @loan_kws - ["installment loans", "payday loans"] #pulls out the main terms, the list is used on these pages only
      @loan_kws.each do |kw|
        hold.push("<a href= \"/#{kw.gsub(' ','-')}\">#{kw}</a>") if kw.include? filter #creates link from each remaining term
      end  
      @loan_kws = hold

      #creates pared list for lenders
      hold=[] 
      @lender_kws = @lender_kws - ["installment loan lenders", "payday lenders"] #pulls out the main terms, the list is used on these pages only
      @lender_kws.each do |kw|
        hold.push("<a href= \"/#{kw.gsub(' ','-')}\">#{kw}</a>") if kw.include? filter #creates link from each remaining term
      end  
      @lender_kws = hold

  end


end
