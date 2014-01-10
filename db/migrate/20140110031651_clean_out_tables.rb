class CleanOutTables < ActiveRecord::Migration

 def up
 	drop_table :sources
 	drop_table :pages
 	drop_table :lenders
 	drop_table :lenders_term_states
 	drop_table :term_states
 	drop_table :lenders_states


 end
 def down

 	create_table :lenders_states, :id => false do |t|
  		t.integer "lender_id"
  		t.integer "state_id" 		
 	end
 	add_index :lenders_states, ["lender_id", "state_id"]  	 

  create_table :term_states do |t|
	  t.string "state_abbr", :limit => 2
	  t.string "state", :limit =>15
      t.timestamps
  end 

 	create_table :lenders_term_states, :id => false do |t|
  		t.integer "lender_id"
  		t.integer "term_state_id" 		
 	end
 	add_index :lenders_term_states, ["lender_id", "term_state_id"] 

    create_table :lenders do |t|
    t.integer "sniff_id"
    t.integer "partner_id"
    t.string "name", :limit => 45
    t.string "lender_type", :limit => 45
    t.string "image_file"
    t.decimal "ranking", :precision => 3, :scale => 1
    t.string "first_comment"
    t.string "second_comment"	
    t.string "third_comment"
    t.string "since", :limit => 4
    t.string "governing_law", :limit => 45
    t.boolean "BBB_accredit"
    t.string "BBB_score", :limit => 4
    t.integer "BBB_complaints"
    t.integer "BBB_unresponded"
	  t.string "max_loan", :limit => 45
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
	  t.decimal "loan_amt", :precision => 6, :scale =>2
	  t.decimal "payments", :precision => 4, :scale =>1
	  t.decimal "pmt_freq_in_days", :precision => 5, :scale =>1
	  t.decimal "pmt_amt", :precision => 7, :scale =>2
	  t.decimal "cost", :precision => 7, :scale =>2
	  t.decimal "apr", :precision => 3, :scale =>2
	  t.string "review_url"
      t.timestamps
    end
    
    add_index("lenders", "sniff_id")

    create_table :pages do |t|
	  	t.string "page_name", :limit => 50
	  	t.string "page_code", :limit => 4
      t.timestamps
    end

    add_index(:pages, :page_code, :unique => true)    

    create_table :sources do |t|
      t.string "src_code", :limit => 4
      t.string "src_desc", :limit => 50
      t.timestamps
    end
    add_index(:sources, :src_code, :unique => true)
    
 end

end
