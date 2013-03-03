class CreateSecureds < ActiveRecord::Migration
  def change
    create_table :secureds do |t|
      t.string "name", :limit => 70
      t.string "lender_link", :limit => 100
      t.string "lender_tail", :limit => 100
      t.string "image_file", :limit => 100
      t.decimal "rating", :precision => 3, :scale => 1
      t.string "first_comment", :limit => 70
      t.string "second_comment", :limit => 70
      t.string "third_comment", :limit => 70
	  t.decimal "purchase_apr", :precision => 4, :scale =>2 
	  t.decimal "annual_fee", :precision => 5, :scale =>2
	  t.decimal "monthly_fee", :precision => 4, :scale =>2	  
	  t.decimal "cost", :precision => 7, :scale =>2     
      t.timestamps
    end
  end
end
