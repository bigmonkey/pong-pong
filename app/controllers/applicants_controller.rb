class ApplicantsController < ApplicationController

	require 'nokogiri'
	require 'open-uri'

  def index
	  @applicant = Applicant.new  
  end

  def create
		# @applicant.save(:last_name => params[:last_name], :first_name => params[:first_name])
		if @applicant = Applicant.create(params[:applicant])
		  @applicant.save
#			uri = URI.parse("https://system.t3leads.com/system/lead_channel/server_post.php")						

#			http = Net::HTTP.new(uri.host, uri.port)
#			http.use_ssl = true
#			http.verify_mode = OpenSSL::SSL::VERIFY_NONE			

#			request = Net::HTTP::Get.new(uri.request_uri)	

#			@response = http.request(request)			
			puts "hello world wait a second"

			doc = Nokogiri::XML(open("http://system.t3leads.com/system/lead_channel/server_post.php"))
			doc.xpath('//Description').each do |node|
			puts node.text
			end
		else
		  # error handling
		end

  end

end
