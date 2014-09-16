ActiveAdmin.register Post do


  permit_params :title,
                :author,
                :author_url,
                :article,
                :seo_title,
                :description,
                :slug,
                :created_at,
                :updated_at,
                posts_topics_attributes: [:id, :post_id, :topic_id, :destroy]
  
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
      #f.input :created_at
      f.input :updated_at, as: :date_select
      f.input :article
    end
    f.actions
    f.inputs do
      f.has_many :posts_topics do |app_f|
        if app_f.object.id
          app_f.input :_destroy, as: :boolean, label: "delete"
        end
        app_f.input :topic, include_blank: :false, :member_label => :topic
      end 
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
      panel "Topics" do
        table_for post.posts_topics do
          column "Topics" do |t|
            t.topic.topic
          end
          column "Slug" do |t|
            t.topic.slug
          end
        end
      end 
    end      
    active_admin_comments
  end

end
