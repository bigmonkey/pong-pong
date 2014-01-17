class AlterApplicants < ActiveRecord::Migration
  def up
  	change_table :applicants do |t|
  		t.remove :src_code, :page_code
      t.string :visitor_token
  		t.integer :requested_amount
  		t.string :device
  		t.string :src
  		t.string :referer_uri
      t.string :referer_host
      t.string :referer_path
      t.string :referer_query
  		t.string :entry_page
  		t.integer :page_views
  		t.string :time_on_site
  		t.string :exit_page
  	end
  end

  def down
  	change_table :applicants do |t|
  		t.remove :exit_page, :time_on_site, :page_views, :entry_page, :referer_query, :referer_path, :referer_host, :referer_uri, :src, :device, :requested_amount, :visitor_token
	  	t.string "page_code", :limit => 4
      t.string "src_code", :limit => 4
  	end
  end  
end
