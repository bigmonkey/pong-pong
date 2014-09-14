ActiveAdmin.register Keyword do

  
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

  permit_params :word, :phrase, :state_phrase, :category, :article, :parent_page, :controller
  

  index do
    column :word
    column :category
    column :parent_page
    column :controller
    actions
  end

  filter :word
  filter :controller
  filter :category
  filter :parent_page
  filter :controller

  form do |f|
    f.inputs "Keyword Details" do
      f.input :word, :label => "Keyword"
      f.input :phrase, :label => "Phrase (plural/noun)"
      f.input :state_phrase, :label => "Select Tag ('Compare Loans')" 
      f.input :category, :label => "Category (selects copy)",:as => :select, :collection => Keyword.select('category').group('category').order('category ASC').map {|k| k.category}
      f.input :article, :label => "Article (category = custom, use html)"
      f.input :parent_page, :label => "Parent Page (linked from)", :as => :select, :collection => Keyword.all.map { |k| k.word }
      f.input :controller, :as => :select, :collection => Keyword.select('controller').group('controller').order('controller ASC').map {|k| k.controller}
    end
    f.actions
  end

end
