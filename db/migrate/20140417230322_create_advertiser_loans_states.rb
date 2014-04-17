class CreateAdvertiserLoansStates < ActiveRecord::Migration
  def change
    create_table :advertiser_loans_states do |t|
      t.belongs_to :advertiser_loan
  		t.belongs_to :state
      t.timestamps
    end
  end
end
