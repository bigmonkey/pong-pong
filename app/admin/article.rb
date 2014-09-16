ActiveAdmin.register Article do

  permit_params :title,
                :author,
                :author_url,
                :article,
                :seo_title,
                :description,
                :slug,
                :created_at,
                :updated_at,
                articles_topics_attributes: [:id, :article_id, :topic_id, :destroy]
  
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
      f.inputs do
        f.has_many :articles_topics do |c|
          if c.object.id
            c.input :destroy, as: :boolean, label: "delete"
          end
          c.input :topic, include_blank: :false, member_label: :topic
        end
      end
      f.input :created_at
      f.input :updated_at
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
