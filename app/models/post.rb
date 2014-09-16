class Post < ActiveRecord::Base
	has_many :posts_topics
	has_many :topics, through: :posts_topics
	accepts_nested_attributes_for :posts_topics, allow_destroy: true

	validates :title, presence: true
	validates :slug, presence: true

	def self.created
		order(created_at: :desc)
	end	
end
