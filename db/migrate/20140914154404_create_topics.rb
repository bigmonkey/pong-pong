class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
    	t.string :topic
    	t.string :slug
    	t.decimal :display_order
      t.timestamps
    end
  end
end
