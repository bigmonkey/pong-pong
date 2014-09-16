class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string :title
    	t.string :author
    	t.string :author_url
    	t.text :article
    	t.string :seo_title
			t.string :description    	
    	t.string :slug
      t.timestamps
    end
  end
end
