class AlterPrepaidsAndSecureds < ActiveRecord::Migration
  def up
  	add_column("prepaids", "review_url", :string)
  	add_column("secureds", "review_url", :string)
  	add_index("prepaids", "review_url")
  	add_index("secureds", "review_url")
  end

  def down
  	remove_index("secureds", :column => "review_url")
  	remove_index("prepaids", :column => "review_url")  	
  	remove_column("secureds", "review_url")  
		remove_column("prepaids", "review_url")
  end
end
