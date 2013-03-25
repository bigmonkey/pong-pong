class PaydayLoansStatesJoin < ActiveRecord::Migration
  def up
  	create_table :payday_loans_states, :id => false do |t|
   		t.integer "payday_loan_id"
   		t.integer "state_id" 		
  	end
  	add_index :payday_loans_states, ["payday_loan_id", "state_id"]  	 
  	
  end

  def down
  	drop_table :payday_loans_states
  end
end
