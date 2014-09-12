ActiveAdmin.register Article do

  permit_params :title,
                :author,
                :author_url,
                :article,
                :SEO_title,
                :description,
                :url
  
  index do
    column :title
    column :author
    default_actions
  end
  
  filter :created_at
  
  form do |f|
    f.actions 
    f.inputs "Article Details" do
      f.input :title
      f.input :author
      f.input :author_url
      f.input :SEO_title
      f.input :description
      f.input :url
      f.input :article
    end
    f.actions
  end
  
  show do
    attributes_table do
      row :title
      row :author
      row :author_url
      row :SEO_title
      row :description
      row :url
      row :article
    end
    active_admin_comments
  end
end
