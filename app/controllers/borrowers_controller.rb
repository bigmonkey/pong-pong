class BorrowersController < ApplicationController

  layout 'public'    

  before_filter :set_tracking
  
	require 'nokogiri'
	require 'open-uri'

  def new
  	@borrower = Borrower.new
  	@requested_amount = params[:requested_amount]
  end

  def create

		if @borrower = Borrower.create(params[:applicant])

			# set variables
			# t3 variables
			@t3header = {"id" => "1.40896", "password" => "NGvDjqwxSeXvAYleYkyW", "client_ip_address" => request.remote_ip, "minimum_price" => "0", "subaccount" => "0000", "test_status" => "sold"}

			@bigmama=params[:borrower].merge(@t3header)
			@response = Nokogiri::XML(open("http://system.t3leads.com/system/lead_channel/server_post.php",@bigmama))
			case @response.xpath('//Status').text
			when "sold"
				@redirect = @response.xpath('//Redirect').text
				@borrower.price = @response.xpath('//Price').text
			when "reject", "duplicate"
				@redirect = "http://www.mobilespinner.com"
			else "error"
				@redirect = "http://www.mobilespinner.com"
				@borrower.description = @response.xpath('//Description').text
			end
			@borrower.leadid = @response.xpath('//LeadID').text
			@borrower.save

		else
		  # error handling
		end


  end
end
