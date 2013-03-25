class CreatePaydayLoanLawDetails < ActiveRecord::Migration
  def change
    create_table :payday_loan_law_details do |t|
			t.string "state_abbr"
			t.string "ncsl_citation"
			t.text "ncsl_max_loans"
			t.text "ncsl_max_term"
			t.text "ncsl_citation_excerpt"
			t.timestamps
    end
  end
end
