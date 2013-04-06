class AlterPaydayAndTermLoans < ActiveRecord::Migration
  def up
		add_column("payday_loans", "full_desc", :text)
		add_column("payday_loans", "image_file_big", :string)
		add_column("payday_loans", "bbb_link", :string)
		add_column("payday_loans", "link1_desc", :string)
		add_column("payday_loans", "link1", :string)
		add_column("payday_loans", "link2_desc", :string)
		add_column("payday_loans", "link2", :string)
		add_column("term_loans", "full_desc", :text)
		add_column("term_loans", "image_file_big", :string)
		add_column("term_loans", "bbb_link", :string)
		add_column("term_loans", "link1_desc", :string)
		add_column("term_loans", "link1", :string)
		add_column("term_loans", "link2_desc", :string)
		add_column("term_loans", "link2", :string)

  end

  def down
		remove_column("term_loans", "link2")
		remove_column("term_loans", "link2_desc")
		remove_column("term_loans", "link1")
		remove_column("term_loans", "link1_desc")
		remove_column("term_loans", "bbb_link")
		remove_column("term_loans", "image_file_big")
		remove_column("term_loans", "full_desc")
		remove_column("payday_loans", "link2")
		remove_column("payday_loans", "link2_desc")
		remove_column("payday_loans", "link1")
		remove_column("payday_loans", "link1_desc")
		remove_column("payday_loans", "bbb_link")
		remove_column("payday_loans", "image_file_big")
		remove_column("payday_loans", "full_desc")
  end
end
