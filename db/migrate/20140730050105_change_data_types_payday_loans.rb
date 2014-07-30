class ChangeDataTypesPaydayLoans < ActiveRecord::Migration
  def up
    change_column :payday_loans, :loan_amt, :string
    change_column :payday_loans, :payments, :string
    change_column :payday_loans, :pmt_freq_in_days, :string
    change_column :payday_loans, :pmt_amt, :string
    change_column :payday_loans, :cost, :string
    change_column :payday_loans, :apr, :string
  end

  def down
  	remove_column :payday_loans, :apr
    remove_column :payday_loans, :cost
    remove_column :payday_loans, :pmt_amt
    remove_column :payday_loans, :pmt_freq_in_days
    remove_column :payday_loans, :payments
    remove_column :payday_loans, :loan_amt
    add_column :payday_loans, :apr, :decimal, precision: 3, scale: 2
    add_column :payday_loans, :cost, :decimal, precision: 7, scale: 2
    add_column :payday_loans, :pmt_amt, :decimal, precision: 7, scale: 2
    add_column :payday_loans, :pmt_freq_in_days, :decimal, precision: 5, scale: 1
    add_column :payday_loans, :payments, :decimal, precision: 4 , scale: 1
    add_column :payday_loans, :loan_amt, :decimal, precision: 6, scale: 2
  end
end
