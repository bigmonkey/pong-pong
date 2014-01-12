class ApplicationController < ActionController::Base
  
  #method defined below and redirects to home
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  include ApplicationHelper #include methods for mobile and tablet regex

  def routes
    binding.pry    
    redirect_to ("http://www.thepaydayhound.com/learn" + request.fullpath), :status => 301
  end 

  #not working because of heroku routing nginx reverse proxy
  def heroku
    redirect_to ("http://www.thepaydayhound.com" + request.fullpath), :status => 301
  end

  protect_from_forgery

  protected

  # determines type of device using user agent
  # tablets_agents, mobile_agents_one, and mobile_agents_two are RegEx in ApplicationHelper
  def set_device
      # if HTTP_USER_AGENT is blank/nil defaults to blank, i.e. desktop 
      agent = request.env["HTTP_USER_AGENT"].blank? ? "" : request.env["HTTP_USER_AGENT"].downcase 
      if agent =~ tablet_agents
        "tablet"
      elsif (agent =~ mobile_agents_one) || (agent[0..3] =~ mobile_agents_two)
        "mobile"
      else
        "desktop"
      end  
  end

  # TRACKING VARIABLES from external (put in URL pointing to PDH)
  # src -- the source of a visitor
  # camp -- the campaign of a visitor. this includes device, country
  # adg -- the ad groub of a visitor. 
  # kw -- the keyword of a visitor. 
  # ad -- the ad of a visitor. creative
  # plc -- the placement of a visitor. website.


  def set_tracking
    # set ad campaign stats if a source is in the url
  	if !params[:src].nil?
      session[:src] = params[:src] 
      session[:camp] = params[:camp]
      session[:adgrp] = params[:adg]
      session[:kw] = params[:kw]
      session[:ad] = params[:ad]
      session[:plc] = params[:plc]
    end

    # set site tracking stats
    if session[:page_views].nil?
      session[:page_views] = 1  
      #for direct visitors session[:referer_uri] is nil
      session[:referer_uri] = request.env["HTTP_REFERER"]
      session[:device] = set_device
      session[:entry_page] = request.fullpath
      session[:entry_time] = Time.now
    else
      session[:page_views] += 1
    end
  end

  def save_tracking

    @applicant = Applicant.new

    # assign tracking stats
    @applicant.ip_address = request.remote_ip
    @applicant.redirect = @redirect
    @applicant.device = session[:device]
    @applicant.src = session[:src] 
    @applicant.referer_uri = session[:referer_uri]
    if !session[:referer_uri].nil?
      uri = URI(session[:referer_uri])
      @applicant.referer_host = uri.host
      @applicant.referer_path = uri.path
      @applicant.referer_query = uri.query
    end  
    @applicant.entry_page = session[:entry_page]
    @applicant.page_views = session[:page_views]
    if !session[:entry_time].nil?
      @applicant.time_on_site = Time.at(Time.now - session[:entry_time]).utc.strftime("%H:%M:%S")
    end
    @applicant.exit_page = session[:exit_page]

    # assign campaign stats 
    @applicant.campaign = session[:camp]
    @applicant.ad_group = session[:adgrp]
    @applicant.kw = session[:kw]
    @applicant.creative = session[:ad]
    @applicant.placement = session[:plc]

    # save prequal variables
    @applicant.overdraft_protection = params[:overdraft_protection] 
    @applicant.payday_loan_history = params[:payday_loan_history] 
    @applicant.speed_sensitivity = params[:speed_sensitivity]
    @applicant.price_sensitivity = params[:price_sensitivity]
    @applicant.licensed_sensitivity = params[:licensed_sensitivity]
    @applicant.creditcard_own = params[:creditcard_own]
    @applicant.active_military = params[:active_military] 
    @applicant.eighteen = params[:eighteen]
    @applicant.state = params[:state]
    @applicant.bank_account_type = params[:bank_account_type]

    @applicant.save 
  
    # @applicant.token is created in model applicant.rb
    # session[:token] is set so it can be sent to affiliates for tracking
    session[:token]=@applicant.token
  end

  #in application because blogbars calls this method for wordpress
  def set_secured_constants
    @pur_balance =  500.0 #revolving purchase balance
    @cash_balance = 0.0 #cash balance balance
    @duration = 8.0  #number of months someone keeps the secured car, ad decimal so not integer  
  end
  
  #in application because blogbars calls this method for wordpress
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
      # @keyword.category broken into three categories: custom, custom_state, loans, and lenders. Used for copy choices in index
      #   custom -- feeds text from table
      #   custom_state -- feeds text from table plus adds state selector
      #   loans/lenders -- uses copy for loans/lenders
      # @keyword.controller is used in routes to direct kw to correct controller. Issues with making one controller and one lender tables is need to make separate rows for term and payday for pricing and then when calling lender from Wordpress it's not clear which row to use. Solution is to create new tables for pricing and keep lender information as single row. 
      # @keyword.word seo target kw
      # @keyword.state_phrase the title of the state selector table. ex compare plural
      # @keyword.phrase seo target kw in a phrase with a plural noun . Copy assumes plural. Quick Loan becomes Quick Loan Options
      # @keyword.slug IS NOT USED ANYMORE see below
      # --------- future update -------- noticed 12/9/2013
      # NOTE slug and word must be exactly the same except for spaces.
      # find_by_slug and @selector_path but to do related_keywords array could not use slug so used gsub
      # improvement -- remove this dependency and use gsub.
      # --------- update completed: @keyword.slug is no longer used 1/7/2014 --------

      #captures stuff between first two slases
      slug = request.fullpath.split(/\//)[1]

      #used in state_selector
      @selector_path = "/"+slug 

      # find_by! raised RecordNotFound exception if not record exits. private method below escapes exception and redirects to home
      @keyword = Keyword.find_by_word!(slug.gsub('-',' ')) 

      # related_kw_links is used to make sure all kw's are hooked into site tree
      # All must be linked back to a kw on one of the major menu pages such as: /payday-loans, /installment-loans or /learn
      # for /payday-loans and /installment-loans these pages show up automatically using related_kw_links
      related_keywords = Keyword.where(:parent_page => @keyword.word).pluck(:word) - [].push(@keyword.word)  #remove current kw because don't want list of related kw containing the same kw
      @related_kw_links = []
      related_keywords.each do |word|
        @related_kw_links.push("<a href = \"/#{word.gsub(' ','-')}/\">#{word}</a>") #creates links for the related kws
      end  
  end

  private

  # gets called by find_by bang above if no record found
  def record_not_found
    redirect_to("/")
  end

end
