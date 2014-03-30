ActiveAdmin.register Banner do

  permit_params   :name,
                  :rotation_rank,
                  :size_160x600,
                  :partner_id

  index do
    column :name
    column :image do |b| link_to(image_tag(b.size_160x600.url(:thumb)), admin_banner_path(b.id)) end
    column :partner
    column :rotation_rank
    default_actions
  end

  form html: { multipart: true } do |f|
    f.inputs "Banner Details" do
      f.input :partner
      f.input :name
      f.input :rotation_rank, label: 'Number 1-10'
    end

    f.inputs "Banner Image" do
      f.input :size_160x600, as: :file, required: false
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :image do |b| image_tag b.size_160x600.url end
      row :partner
      row :rotation_rank
    end
    active_admin_comments
  end
end
