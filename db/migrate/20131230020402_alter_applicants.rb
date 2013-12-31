class AlterApplicants < ActiveRecord::Migration
  def up
  	change_table :applicants do |t|
  		t.remove :src_code, :page_code
  		t.integer :requested_amount
  		t.string :device
  		t.string :src
  		t.string :referal_uri
      t.string :referal_host
      t.string :referal_path
      t.string :referal_query
  		t.string :entry_page
  		t.integer :page_visits
  		t.string :time_on_site
  		t.string :exit_page
  	end
  end

  def down
  	change_table :applicants do |t|
  		t.remove :exit_page, :time_on_site, :page_visits, :entry_page, :referal_query, :referal_path, :referal_host, :referal_uri, :src, :device, :requested_amount
	  	t.string "page_code", :limit => 4
      t.string "src_code", :limit => 4
  	end
  end  
end
