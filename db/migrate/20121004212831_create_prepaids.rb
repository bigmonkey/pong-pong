class CreatePrepaids < ActiveRecord::Migration
  def change
    create_table :prepaids do |t|
		  t.integer "partner_id"
		  t.string "name", :limit => 100
		  t.string "image_file", :limit => 100
		  t.string "card_name", :limit => 100
	    t.decimal "rating", :precision => 3, :scale => 1	  
		  t.string "credit_needed", :limit => 25
		  t.string "first_comment", :limit => 70
		  t.string "second_comment", :limit => 70
			t.string "third_comment", :limit => 70
		  t.decimal "activation_fee", :precision => 4, :scale => 2
		  t.decimal "reduce_mth_fee_load_amt", :precision => 8, :scale => 2
		  t.decimal "reduce_mth_fee", :precision => 4, :scale => 2
		  t.decimal "mth_fee_dep", :precision => 4, :scale => 2
		  t.decimal "mth_fee_no_dep", :precision => 4, :scale => 2
		  t.decimal "trans_fee_signature", :precision => 4, :scale => 2
		  t.decimal "atm_bal_fee", :precision => 4, :scale => 2
		  t.decimal "atm_out_net_fee", :precision => 4, :scale => 2
		  t.decimal "atm_in_net_fee_dep", :precision => 4, :scale => 2
		  t.decimal "atm_in_net_fee_no_dep", :precision => 4, :scale => 2
		  t.decimal "load_fee", :precision => 4, :scale => 2
		  t.decimal "paper_statement", :precision => 4, :scale => 2
		  t.decimal "max_atm", :precision => 8, :scale => 2
		  t.decimal "max_bal", :precision => 8, :scale => 2
		  t.decimal "max_daily_spend", :precision => 8, :scale => 2
		  t.decimal "min_load", :precision => 8, :scale => 2
		  t.decimal "max_cash_deposit", :precision => 8, :scale => 2
		  t.string "bill_pay_elec", :limit => 70
		  t.string "bill_pay_paper", :limit => 70
		  t.string "online_acct", :limit => 20
		  t.decimal "call_fee_dep", :precision => 4, :scale => 2
		  t.decimal "call_fee_no_dep", :precision => 4, :scale => 2
		  t.decimal "free_calls", :precision => 4, :scale => 2
		  t.string "call_center_desc", :limit => 100
		  t.text "bullets"
		  t.string "issuer", :limit => 100
		  t.decimal "payout", :precision => 4, :scale => 2
		  t.boolean "live"
		  t.integer "card_syn_id"
      t.timestamps
    end
  end
end
