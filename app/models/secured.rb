class Secured < ActiveRecord::Base
  # attr_accessible :title, :body
  
  scope :by_top_rank, order("secureds.rating DESC")  

  # filters out secured cards that we can show live on the site
    def self.live
		where("live = ?", true)
    end

end

