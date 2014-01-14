ActiveAdmin.register TermLoan do

  remove_filter :states_term_loans
 
  index do
    column :name do |l| image_tag("lendersm/#{l.image_file}") end
    column :sniff_id do |s| s.sniff.sniff_desc end
    column :active, :as => :check_box
    column :ranking
    column :first_comment
    column :second_comment
    column :third_comment
    column :since
    column :governing_law
    column :loan_amt
    column :payments
    column :pmt_freq_in_days
    column :pmt_amt
    column :cost
    column :apr
    default_actions
  end

  filter :name
  filter :sniff_id 
  filter :ranking

  form do |f|
    f.inputs "Lender Details" do
      f.input :sniff, :member_label => :sniff_desc
      f.input :partner, :member_label => :name
      f.input :name
      f.input :active
      f.input :lender_type
      f.input :image_file
      f.input :ranking
      f.input :first_comment
      f.input :second_comment
      f.input :third_comment
      f.input :review_url
      f.input :since
      f.input :governing_law
      f.input :BBB_accredit, :label => "BBB Accredited"
      f.input :BBB_score, :label => "BBB Score"
      f.input :BBB_complaints, :label => "BBB Complaints"
      f.input :BBB_unresponded, :label => "BBB Complaint Unresponded"
      f.input :max_loan, :label => "Max Loan"
      f.input :spanish
      f.input :state_lic
      f.input :privacy_policy
      f.input :https
      f.input :phone_contact
      f.input :live_chat
      f.input :loan_amt
      f.input :payments
      f.input :pmt_freq_in_days
      f.input :pmt_amt
      f.input :cost
      f.input :apr
      f.input :full_desc
      f.input :image_file_big
      f.input :bbb_link
      f.input :link1_desc
      f.input :link1
      f.input :link2_desc
      f.input :link2
    end
    f.actions
  end

end
