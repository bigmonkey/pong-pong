class BorrowersController < ApplicationController

  layout :resolve_layout

# DO NOT set_tracking
# Only way to get here is through controller: applicants. Tracking is set there.
# If tracking is set here variables will be wiped out.

  
	require 'nokogiri'
	require 'open-uri'

	def save_tracking
		@applicant = Applicant.new

		@applicant.ip_address = request.remote_ip

		# saves tracking variable 
		@applicant.src = session[:src] 
		@applicant.exit_page = @page
    @applicant.campaign = session[:camp]
    @applicant.ad_group = session[:adgrp]
    @applicant.kw = session[:kw]
    @applicant.creative = session[:ad]
    @applicant.placement = session[:plc]
   	# saves marketing variables
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
   	@applicant.redirect = @redirect
   	@applicant.save 
	
		# @applicant.token is created in model applicant.rb
		# session[:token] is set so it can be sent to affiliates for tracking
		session[:token]=@applicant.token

	end

  def new
  	
  	# @redirect is used in save_tracking
  	#binding.pry
  	if ( params[:active_military].blank? || params[:bank_account_type].blank? || params[:state].blank? || params[:requested_amount].blank? ) 
  		redirect_to applicants_path  	
  	elsif	
	  	 (params[:active_military]=="true") or (params[:bank_account_type]=="NONE") or (params[:eighteen]=="false")
	  		@redirect = "http://usmilitary.about.com/od/millegislation/a/paydayloans.htm"
	  		save_tracking
	  		redirect_to(@redirect)
  	else	
  		case params[:state]
	  	when "GA","VA","WV","AR","NY","PA","OH"
	  		@redirect = "#{params[:state]} Loan Laws"
	  		save_tracking
	  		redirect_to("/payday-loans/#{params[:state]}")
	  	else 
	  		@redirect = "borrower/new"
	  		save_tracking
		  	@borrower = Borrower.new
		  	@requested_amount = params[:requested_amount]	
		  	if !State.find_by_state_abbr(params[:state]).nil?
		  		@state_name= State.find_by_state_abbr(params[:state]).state
		  	else
		  		@state_name=params[:state]
		  	end	
	  	end	
	  end					
  end


  def pingtree
		# set variables
		# t3 variables		
		@t3header = {"id" => "2.40896", "password" => "TFTQEcvpoAxUkdduxiiU", "client_ip_address" => @borrower.ip_address, "minimum_price" => "0", "subaccount" => "0000", "test_status" => "sold"}
		t3pingurl = "https://system.t3leads.com/system/lead_channel/server_post.php?"+params[:borrower].merge(@t3header).to_query
		@response = Nokogiri::XML(open(t3pingurl))
		


		case @response.xpath('//Status').text
		when "sold"
			@borrower.redirect = @response.xpath('//Redirect').text
			@borrower.sold_price = @response.xpath('//Price').text
		when "reject", "duplicate"
			@borrower.redirect = "http://www.mobilespinner.com"
		when "error"
			@borrower.redirect = "http://www.mobilespinner.com"
			@borrower.error_description = @response.xpath('//Description').text
		else
			@borrower.redirect = "http://www.mobilespinner.com"
		end

		# leadid is same for all responses so saved at the end
		@borrower.leadid = @response.xpath('//LeadID').text		
		@borrower.save 



  end

  def create
  	# to code list:
  	# make sure came from new -- hidden fields are present. if not send back to new
		
  	@borrower = Borrower.create(params[:borrower])
  		params[:borrower]['birth_date']=Date.new(params[:borrower]['bir_year'].to_i, params[:borrower]['birth_mth'].to_i, params[:borrower]['bir_day'].to_i)
			pingtree
  		@lender_url = @borrower.redirect		
	end

  private

  def resolve_layout
    case action_name
    when "create"
      "partner"
    else 
      "homeNav"
    end
  end




end
