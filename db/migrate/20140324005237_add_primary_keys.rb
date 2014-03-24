class AddPrimaryKeys < ActiveRecord::Migration
  def change
  	remove_index :states_term_loans, column: ["term_loan_id", "state_id"]  	 
  	drop_table :states_term_loans, :id => false do |t|
   		t.integer "term_loan_id"
   		t.integer "state_id" 		
  	end

  	remove_index :payday_loans_states, column: ["payday_loan_id", "state_id"]  	   	
  	drop_table :payday_loans_states, :id => false do |t|
   		t.integer "payday_loan_id"
   		t.integer "state_id" 		
  	end

  	create_table :states_term_loans do |t|
  		t.belongs_to :state
  		t.belongs_to :term_loan
  		t.timestamps
  	end

  	create_table :payday_loans_states do |t|
  		t.belongs_to :state
  		t.belongs_to :payday_loan
  		t.timestamps
  	end

  end
end
