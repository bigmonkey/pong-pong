ActiveAdmin.register Article do

  permit_params :title,
                :author,
                :author_url,
                :article,
                :seo_title,
                :description,
                :slug
  
  index do
    column :title
    column :author
    actions
  end
  
  filter :created_at
  
  form do |f|
    f.actions 
    f.inputs "Article Details" do
      f.input :title
      f.input :author
      f.input :author_url
      f.input :seo_title
      f.input :description
      f.input :slug
      f.input :article
    end
    f.actions
  end
  
  show do
    attributes_table do
      row :title
      row :author
      row :author_url
      row :seo_title
      row :description
      row :slug
      row :article
    end
    active_admin_comments
  end
end
