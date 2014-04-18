ActiveAdmin.register AdvertiserLoan do
  permit_params :sniff_id,
                :partner_id,
                :name,
                :active,
                :lender_type,
                :paid,
                advertiser_loans_states_attributes: [:id, :state_id, :term_loan_id, :_destroy]

  config.sort_order = "ranking_desc"
  index do
    column :id
    column :name 
    column :active, :as => :check_box
    column :paid, as: :check_box
    default_actions
  end

  filter :name
  filter :sniff_id 
  filter :ranking

  form do |f|
    f.actions
    f.inputs "Lender Details" do
      f.input :sniff, :member_label => :sniff_desc
      f.input :partner
      f.input :name
      f.input :active
      f.input :paid
      f.input :lender_type, :input_html => { :value => "advertiser" }
 
    end
    f.actions
    f.inputs do
      f.has_many :advertiser_loans_states do |app_f|
        if app_f.object.id
          app_f.input :_destroy, as: :boolean, label: "delete"
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
      row :paid
      row :lender_type, :input_html => { :value => "advertiser" }

    end
    panel "Available States" do
      table_for advertiser_loan.advertiser_loans_states do
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
