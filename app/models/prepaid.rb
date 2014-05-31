class Prepaid < ActiveRecord::Base
  # attr_accessible :title, :body


  #scope :by_top_rank, order("prepaids.rating DESC")  
    def self.by_top_rank
    	order(rating: :desc)
    end
    
  # filters out secured cards that we can show live on the site
    def self.live
		where("live = ?", true)
    end

end
