ActiveAdmin.register Topic do

  permit_params :topic,
                :slug,
                :display_order

  index do
    column :topic
    column :slug
    column :display_order
    actions
  end

  form do |f|
    f.actions
    f.inputs "Topic Details" do
      f.input :topic
      f.input :slug
      f.input :display_order
    end
  end

  show do 
    attributes_table do 
      row :topic
      row :slug
      row :display_order
    end
    active_admin_comments
  end
end
