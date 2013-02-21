class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
			t.boolean "active_military"
			t.string "address", :limit => 128
			t.integer "address_length_months"
			t.integer "bank_aba"
			t.integer "bank_account_length_months"
			t.integer "bank_account_number"
			t.string "bank_account_type", :limit => 8
			t.string "bank_name", :limit => 128
			t.string "bank_phone", :limit => 12
			t.string "best_time_to_call", :limit => 12
			t.date "birth_date"
			t.string "city", :limit => 128
			t.boolean "direct_deposit"
			t.string "drivers_license_number", :limit => 128
			t.string "drivers_license_state", :limit => 2
			t.string "email", :limit => 128
			t.integer "employed_months"
			t.string "employer", :limit => 128
			t.string "first_name", :limit => 128
			t.string "home_phone", :limit => 12
			t.string "income_type", :limit => 12
			t.string "job_title", :limit => 128
			t.string "last_name", :limit => 128
			t.integer "monthly_income"
			t.boolean "own_home"
			t.date "pay_date1"
			t.date "pay_date2"
			t.string "pay_frequency", :limit => 12
			t.integer "requested_amount"
			t.string "ssn", :limit => 11
			t.string "state", :limit => 2
			t.string "work_phone", :limit => 12
			t.integer "zip"
      t.string "src_code", :limit => 4
	  	t.string "page_code", :limit => 4
			t.string "campaign", :limit => 128
			t.string "ad_group", :limit => 255
			t.string "kw", :limit => 80
			t.string "creative", :limit => 25
			t.string "placement", :limit => 255
		  t.integer "tree", :limit => 128
			t.timestamps
    end
  end
end
