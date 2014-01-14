ActiveAdmin.register Partner do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  permit_params :lender_link,
                :lender_tail,
                :name

  index do 
    column :name
    column :lender_link
    column :lender_tail
    default_actions
  end

  form do |f|
    f.inputs "Partner Details" do
      f.input :name
      f.input :lender_link
      f.input :lender_tail
    end
    f.actions
  end

end 
