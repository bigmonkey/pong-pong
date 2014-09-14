class Article < ActiveRecord::Base

	has_many :articles_topics
	has_many :topics, through: :articles_topics
	accepts_nested_attributes_for :articles_topics, allow_destroy: true

	validates :title, presence: true

	def self.created
		order(created_at: :desc)
	end
end
