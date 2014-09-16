class Topic < ActiveRecord::Base
	has_many :posts_topics
	has_many :posts, through: :posts_topics
	
	validates :topic, presence: true

	def self.disp_order
		order(display_order: :asc)
	end
end
