ActiveAdmin.register Applicant do

  
  index do
    column :id 
    column :visitor_token
    column :token 
    column :entry_page
    column :exit_page
    column :redirect
    column :device
    column :referer_host
    column :page_views
    column :time_on_site
    default_actions
  end

end
