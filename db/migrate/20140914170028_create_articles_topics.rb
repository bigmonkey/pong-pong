class CreateArticlesTopics < ActiveRecord::Migration
  def change
    create_table :articles_topics do |t|
    	t.belongs_to :article
    	t.belongs_to :topic
      t.timestamps
    end
  end
end
