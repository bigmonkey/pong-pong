shared_examples_for "all controllers that set tracking" do
	describe "Tracking Variables" do
		context "Visitor comes from ad partner" do
			it "sets ad campaign stats on first visit" do
				get :index, src: 'ad partner'
				session[:src].should eq('ad partner')
			end		
			it "does not reset campaign stats as user browses pages" do
				get :index, src: 'ad partner'
				get :index
				session[:src].should eq('ad partner')
			end
		end

		
		it "sets session variables" do
			request.env["HTTP_REFERER"] = 'http://test.domain.com'
			get :index
			session[:referer_uri].should eq('http://test.domain.com')
		end	
	end
end