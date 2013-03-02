class CreateBorrowers < ActiveRecord::Migration
  def change
    create_table :borrowers do |t|
    	
    	t.string "token"
    	t.string "ip_address"

    	# personal data
			t.string "first_name", :limit => 128
			t.string "last_name", :limit => 128
			t.string "address", :limit => 128
			t.string "city", :limit => 128
			t.string "state", :limit => 2
			t.string "zip"
			t.integer "address_length_months"
			t.string "ssn", :limit => 11
			t.date "birth_date"
			t.boolean "own_home"	
			t.string "home_phone", :limit => 12	
			t.string "drivers_license_number", :limit => 128
			t.string "drivers_license_state", :limit => 2
			t.string "email", :limit => 128
			t.string "best_time_to_call", :limit => 12

			#bank data
			t.string "bank_aba"
			t.integer "bank_account_length_months"
			t.string "bank_account_number"
			t.string "bank_account_type", :limit => 8
			t.string "bank_name", :limit => 128
			t.string "bank_phone", :limit => 12		
			t.boolean "direct_deposit"			

			#employment
			t.string "employer", :limit => 128
			t.string "job_title", :limit => 128
			t.integer "monthly_income"		
			t.string "income_type", :limit => 12	
			t.string "work_phone", :limit => 12						
			t.date "pay_date1"
			t.date "pay_date2"
			t.string "pay_frequency", :limit => 12
			t.integer "employed_months"
			t.boolean "active_military"

			#loan details
			t.integer "requested_amount"
		  t.string "pingtree"			
	  	t.string "status"
			t.string "leadid"
			t.decimal "sold_price", :precision => 8, :scale => 2
			t.string "redirect"
			t.text "error_description"

      t.timestamps
    end
  end
end
