class CreatePostsTopics < ActiveRecord::Migration
  def change
    create_table :posts_topics do |t|
    	t.belongs_to :post
    	t.belongs_to :topic
      t.timestamps
    end
  end
end
