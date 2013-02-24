class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|

    	t.string "token"

    	#markteing source data
      t.string "src_code", :limit => 4
	  	t.string "page_code", :limit => 4
			t.string "campaign", :limit => 128
			t.string "ad_group", :limit => 255
			t.string "kw", :limit => 80
			t.string "creative", :limit => 25
			t.string "placement", :limit => 255


			#marketing data
			t.boolean "overdraft_protection"
			t.integer "payday_loan_history"
			t.integer "speed_sensitivity"
			t.integer "price_sensitivity"
			t.integer "licensed_sensitivity"
			t.boolean "creditcard_own"

      t.timestamps
    end
  end
end
