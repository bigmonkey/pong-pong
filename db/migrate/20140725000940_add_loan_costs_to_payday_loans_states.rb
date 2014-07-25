class AddLoanCostsToPaydayLoansStates < ActiveRecord::Migration
  def change
    add_column :payday_loans_states, :cost, :decimal, :precision => 7, :scale => 2
    add_column :payday_loans_states, :apr, :decimal, :precision => 3, :scale => 2
    add_column :payday_loans_states, :loan_amt, :decimal, :precision => 6, :scale => 2
  end
end
