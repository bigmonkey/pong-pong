class StatesTermLoansJoin < ActiveRecord::Migration
  def up
  	create_table :states_term_loans, :id => false do |t|
   		t.integer "term_loan_id"
   		t.integer "state_id" 		
  	end
  	add_index :states_term_loans, ["term_loan_id", "state_id"]  	 
  	
  end

  def down
  	drop_table :states_term_loans
  end
end
