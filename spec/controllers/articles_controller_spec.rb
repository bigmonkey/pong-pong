require 'spec_helper'

describe Learn::ArticlesController do

	it "renders the :index view" do
		get :index
		response.should render_template :index
	end	

end
