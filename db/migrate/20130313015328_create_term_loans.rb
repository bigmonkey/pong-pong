class CreateTermLoans < ActiveRecord::Migration
  def change
    create_table :term_loans do |t|
			t.integer "sniff_id"
			t.integer "partner_id"
			t.string "name", :default  =>  ""
			t.boolean "active"
			t.string "lender_type"
			t.string "image_file"
			t.decimal "ranking", :precision => 3, :scale => 1
			t.string "first_comment"
			t.string "second_comment"
			t.string "third_comment"
			t.string "review_url"
			t.string "since"
			t.string "governing_law", :default  =>  ""
			t.boolean "BBB_accredit"
			t.string "BBB_score"
			t.integer "BBB_complaints"
			t.integer "BBB_unresponded"
			t.string "max_loan", :default  =>  ""
			t.boolean "spanish"
			t.boolean "state_lic"
			t.boolean "privacy_policy"
			t.boolean "https"
			t.boolean "phone_contact"
			t.boolean "live_chat"
			t.boolean "time_at_residence"
			t.boolean "rent_or_own"
			t.boolean "rent_mort_amt"
			t.boolean "time_w_employer"
			t.boolean "reference"
			t.decimal "loan_amt", :precision => 6, :scale => 2
			t.decimal "payments", :precision => 4, :scale => 1
			t.decimal "pmt_freq_in_days", :precision => 5, :scale => 1
			t.decimal "pmt_amt", :precision => 7, :scale => 2
			t.decimal "cost", :precision => 7, :scale => 2
			t.decimal "apr", :precision => 3, :scale => 2  
      t.timestamps
    end
  end
end
