class ChangeDataTypesTermLoans < ActiveRecord::Migration
  def up
    change_column :term_loans, :loan_amt, :string
    change_column :term_loans, :payments, :string
    change_column :term_loans, :pmt_freq_in_days, :string
    change_column :term_loans, :pmt_amt, :string
    change_column :term_loans, :cost, :string
    change_column :term_loans, :apr, :string
  end

  def down
    change_column :term_loans, :apr, :decimal, precision: 7, scale: 2
    change_column :term_loans, :cost, :decimal, precision: 7, scale: 2
    change_column :term_loans, :pmt_amt, :decimal, precision: 7, scale: 2
    change_column :term_loans, :pmt_freq_in_days, :decimal, precision: 5, scale: 1
    change_column :term_loans, :payments, :decimal, precision: 4 , scale: 1
    change_column :term_loans, :loan_amt, :decimal, precision: 6, scale: 2
  end
end
