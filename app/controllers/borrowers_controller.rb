class BorrowersController < ApplicationController

  layout 'public'    

  before_filter :set_tracking
  
	require 'nokogiri'
	require 'open-uri'

  def new
  	if (params[:active_military]=="true") or (params[:bank_account_type]=="NONE") or (params[:eighteen]=="false")
  		redirect_to("http://www.cardcred.com")
  	else	
  		case params[:state]
	  	when "GA","VA","WV","AR"
	  		redirect_to("http://www.mobilespinner.com")
	  	else 
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
		@t3header = {"id" => "2.40896", "password" => "TFTQEcvpoAxUkdduxiiU", "client_ip_address" => request.remote_ip, "minimum_price" => "0", "subaccount" => "0000", "test_status" => "sold"}
		t3pingurl="http://system.t3leads.com/system/lead_channel/server_post.php?"+params[:borrower].merge(@t3header).to_query
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

		@borrower.leadid = @response.xpath('//LeadID').text
		
		@borrower.save ? @save = "saved after ping" : "not saved after ping"



  end

  def create
  	# to code list:
  	# make sure came from new -- hidden fields are present. if not send back to new
		
  	if @borrower = Borrower.create(params[:borrower])
  		pingtree
	 	else
	 	end

  end

end
