class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|

    	t.string "token"
    	t.string "ip_address"

    	#markteing source data
      t.string "src_code", :limit => 4
	  	t.string "page_code", :limit => 4
			t.string "campaign"
			t.string "ad_group"
			t.string "kw"
			t.string "creative"
			t.string "placement"

			#marketing data
			t.string "bank_account_type", :limit => 8
			t.boolean "active_military"
			t.boolean "eighteen"			
			t.string "state", :limit => 2			
			t.boolean "overdraft_protection"
			t.integer "payday_loan_history"
			t.integer "speed_sensitivity"
			t.integer "price_sensitivity"
			t.integer "licensed_sensitivity"
			t.boolean "creditcard_own"

			#action data
			t.string "redirect"

      t.timestamps
    end
  end
end
