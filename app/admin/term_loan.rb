ActiveAdmin.register TermLoan do
permit_params :sniff_id,
              :partner_id,
              :name,
              :active,
              :lender_type,
              :image_file,
              :ranking,
              :first_comment,
              :second_comment,
              :third_comment,
              :review_url,
              :since,
              :governing_law,
              :BBB_accredit,
              :BBB_score,
              :BBB_complaints,
              :BBB_unresponded,
              :max_loan,
              :spanish,
              :state_lic,
              :privacy_policy,
              :https,
              :phone_contact,
              :live_chat,
              :loan_amt,
              :payments,
              :pmt_freq_in_days,
              :pmt_amt,
              :cost,
              :apr,
              :full_desc,
              :image_file_big,
              :bbb_link,
              :link1_desc,
              :link1,
              :link2_desc,
              :link2,
              states_term_loans_attributes: [:id, :state_id, :term_loan_id, :_destroy]

  #remove_filter :states_term_loans
 
  index do
    column :id
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
      f.input :partner
      f.input :name
      f.input :active
      f.input :lender_type, :input_html => { :value => "term" }
      f.input :image_file
      f.input :ranking
      f.input :first_comment
      f.input :second_comment
      f.input :third_comment
      f.input :review_url,:label => "Slug for WP"
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
      f.input :full_desc, :label => "Description (HTML)"
      f.input :image_file_big
      f.input :bbb_link, :label => "BBB Link (http://)"
      f.input :link1_desc, :label =>"Link 1 Desc"
      f.input :link1, :label => "Link 1 (http://)"
      f.input :link2_desc, :label =>"Link 2 Desc"
      f.input :link2, :label => "Link 1 (http://)"
    end

    f.inputs do
      f.has_many :states_term_loans do |app_f|
        if app_f.object.id
          app_f.input :_destroy, as: :boolean, label: "delete it bitch"
        end
        app_f.input :state, include_blank: :false, :member_label => :state
      end 
    end
        
    f.actions
  end

  show do
    attributes_table do
      row :sniff do |s| s.sniff.sniff_desc end
      row :partner
      row :name
      row :active
      row :lender_type, :input_html => { :value => "term" }
      row :image_file
      row :ranking
      row :first_comment
      row :second_comment
      row :third_comment
      row :review_url,:label => "Slug for WP"
      row :since
      row :governing_law
      row :BBB_accredit, :label => "BBB Accredited"
      row :BBB_score, :label => "BBB Score"
      row :BBB_complaints, :label => "BBB Complaints"
      row :BBB_unresponded, :label => "BBB Complaint Unresponded"
      row :max_loan, :label => "Max Loan"
      row :spanish
      row :state_lic
      row :privacy_policy
      row :https
      row :phone_contact
      row :live_chat
      row :loan_amt
      row :payments
      row :pmt_freq_in_days
      row :pmt_amt
      row :cost
      row :apr
      row :full_desc, :label => "Description (HTML)"
      row :image_file_big
      row :bbb_link, :label => "BBB Link (http://)"
      row :link1_desc, :label =>"Link 1 Desc"
      row :link1, :label => "Link 1 (http://)"
      row :link2_desc, :label =>"Link 2 Desc"
      row :link2, :label => "Link 1 (http://)"
    end
    panel "Available States" do
      table_for term_loan.states_term_loans do
        column "State" do |s|
          s.state.state
        end
        column "State Abbreviation" do |s|
          s.state.state_abbr
        end
      end
    end       
    active_admin_comments
  end  
end
