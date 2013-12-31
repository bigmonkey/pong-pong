shared_examples_for "all controllers that set tracking" do
	describe "Tracking Variables" do
		context "Visitor comes from ad partner" do
			it "sets ad campaign stats on first visit" do
				get :index, src: 'ad partner', camp: 'campaign'
				session[:src].should eq('ad partner')
				session[:camp].should eq('campaign')
			end		
			it "does not reset campaign stats as user browses pages" do
				get :index, src: 'ad partner', camp: 'campaign'
				get :index
				session[:src].should eq('ad partner')
				session[:camp].should eq('campaign')
			end
		end

		context "Visitor does not come from ad partner" do
			it "does not set ad campaign stats" do
				get :index
				session[:src].should be_nil
				session[:camp].should be_nil
			end		
			it "does not reset campaign stats as user browses pages" do
				get :index
				get :index
				session[:src].should be_nil
				session[:camp].should be_nil
			end
		end
		
		context "Vistor lands on site" do
			it "sets HTTP_REFERER session variable" do
				request.env["HTTP_REFERER"] = 'http://test.domain.com'
				get :index
				session[:referer_uri].should eq('http://test.domain.com')
			end	
			it "sets page views to 1" do
				get :index
				session[:page_views].should eq(1)
			end
			it "sets device" do
				devices = %w[mobile mobile tablet desktop desktop]
				#user agent must be in order of devices array above
				[	
				#iPhone 4
					"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53",
				#HTC One 
					"Mozilla/5.0 (Linux; Android 4.1.2; HTC One Build/JZO54K) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19",
				#ipad
					"Mozilla/5.0 (iPad; CPU OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53", 
				#linux dell chrom
					"Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36",
				#mac air chrom
					"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36"
				].each_with_index do |agent, index|
					session[:page_views] = nil 
					request.env["HTTP_USER_AGENT"] = agent
					get :index
					session[:device].should eq(devices[index])
				end
			end
		end

		context "Visitor browses site" do
			it "does not reset HTTP_REFERER session variable browses" do
				request.env["HTTP_REFERER"] = 'http://test.domain.com'
				get :index
				request.env["HTTP_REFERER"] = 'http://test.domain.com/anotherpage/'
				get :show, id: FactoryGirl.create(:prepaid)
				session[:referer_uri].should eq('http://test.domain.com')
			end		
			it "increments page views by one" do
				session[:page_views] = 1
				get :index
				session[:page_views].should eq(2)
			end
		end
	end
end