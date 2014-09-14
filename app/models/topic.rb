class Topic < ActiveRecord::Base
	has_many :articles_topics
	has_many :articles, through: :articles_topics
	
	validates :topic, presence: true

	def self.disp_order
		order(display_order: :asc)
	end
end
