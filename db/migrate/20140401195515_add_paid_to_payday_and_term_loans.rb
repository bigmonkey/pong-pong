class AddPaidToPaydayAndTermLoans < ActiveRecord::Migration
  def change
		add_column("payday_loans", "paid", :boolean)
		add_column("term_loans", "paid", :boolean)
  end
end
