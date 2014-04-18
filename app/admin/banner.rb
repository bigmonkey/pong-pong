ActiveAdmin.register Banner do
#  actions :all, except: :new

  permit_params   :name,
                  :rotation_rank,
                  :size_160x600,
                  :partner_id,
                  :lender_link,
                  :lender_tail,
                  :lender_type

  index do
    column :id
    column :name
    column :image do |b| link_to(image_tag(b.size_160x600.url(:thumb)), admin_banner_path(b.id)) end
    column :partner
    column :rotation_rank
    default_actions
  end

  # creates new create buttons because banners depend on lender type
  # advertiser are for lenders whom we do not rate but we use only for advertising
  action_item only: :index do
    link_to "New Term Banner", new_admin_banner_path(lender_type: 'term')
  end
  action_item only: :index do
    link_to "New Advertiser Banner", new_admin_banner_path(lender_type: 'advertiser')   
  end
  action_item only: :index do
    link_to "New Payday Banner", new_admin_banner_path(lender_type: 'payday')
  end


  form html: { multipart: true } do |f|

    if params[:id].blank?   
      # lender_type is placed here so it's passed in the params hash.
      # it's needed to create the banner with a polymorphic association to a lender

      f.inputs "Choose #{params[:lender_type].titleize if !params[:lender_type].blank?} Lender Name"do
        f.input :lender_type, as: :hidden,  input_html: { value: params[:lender_type]}  

      # select lenders from tables depending on lender type  
        case params[:lender_type]
          when "payday"
            f.input :name, as: :select, collection: PaydayLoan.all
          when 'advertiser'
            f.input :name, as: :select, collection: AdvertiserLoan.all  
          else "term"
            f.input :name, as: :select, collection: TermLoan.all
          end
      end
      f.inputs "Banner Details" do
        f.input :rotation_rank, label: 'Number 1-10'
        f.input :lender_link, label: 'Lender Link (http://)'
        f.input :lender_tail, label: 'Lender Tail (CJ\'s is \"?sid=\"")'
      end
      f.inputs "Banner Image" do
        f.input :size_160x600, as: :file, required: false
      end
    else
      f.inputs "Update Lender Name and Links" do
        # Edit and New share format. 
        f.input :name
        f.input :rotation_rank
        f.input :lender_link, label: 'Lender Link (http://)', input_html: {value: "#{Banner.find(params[:id]).partner.lender_link}" }
        f.input :lender_tail, label: 'Lender Tail (CJ\'s is \"?sid=\"")', input_html: {value: "#{Banner.find(params[:id]).partner.lender_tail}" }
      end  
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


  controller do

    def create
      # If click on new banner by mistake (can't take it off the action without killing new_admin_banner_path)
      if params[:banner][:lender_type].blank?
        redirect_to admin_banners_path, alert: "Banner NOT created. Please click Term, Payday, or Advertiser Banner"
      elsif params[:banner][:name].blank?
        redirect_to admin_banners_path, alert: "Banner NOT created. Please choose a lender."
      elsif
        # Find the correct lender based on lender_type
        case params[:banner][:lender_type]
        when "payday"
          lender = PaydayLoan.find(params[:banner][:name])        
        when "advertiser"
          lender = AdvertiserLoan.find(params[:banner][:name])
        else "term"

          lender = TermLoan.find(params[:banner][:name])
        end      

        banner_name = lender.name + " 160x600"
        
        #create a new Partner
        partner = Partner.new
        partner.name = banner_name
        partner.lender_link = params[:banner][:lender_link]
        partner.lender_tail = params[:banner][:lender_tail]
        # if partner is not valid it kicks back to index page with error message

        if partner.save    
          #create a new Banner instance
          @banner = lender.banners.new
          @banner.name = banner_name   
          @banner.partner_id = partner.id   
          @banner.rotation_rank = params[:banner][:rotation_rank]
          @banner.size_160x600 = params[:banner][:size_160x600]
          # if banner valid it saves otherwise kicks out to index
          if @banner.save
            redirect_to admin_banner_path(@banner.id), notice: "New banner created."
          else
            redirect_to admin_banners_path, alert: @banner.errors.full_messages.each { |e| puts e }
          end
        else
          redirect_to admin_banners_path, alert: partner.errors.full_messages.each { |e| puts e }
        end
      end  
    end

    def update
      banner = Banner.find(params[:id])
      #create a new Partner
      partner = banner.partner
      partner.lender_link = params[:banner][:lender_link]
      partner.lender_tail = params[:banner][:lender_tail]
      # if partner is not valid it kicks back to index page with error message
      if partner.save    
        #create a new Banner instance
        banner.name = params[:banner][:name]
        banner.rotation_rank = params[:banner][:rotation_rank]   
        # if banner valid it saves otherwise kicks out to index
        if banner.save
          redirect_to admin_banner_path(banner.id), notice: "Banner Updated."
        else
          redirect_to admin_banner_path(banner.id), alert: banner.errors.full_messages.each { |e| puts e }
        end
      else
        redirect_to admin_banner_path(banner.id), alert: partner.errors.full_messages.each { |e| puts e }
      end      
    end

    def destroy
      banner = Banner.find(params[:id])
      banner.partner.destroy
      banner.destroy
      redirect_to admin_banners_path, notice: "Banner Deleted"           
    end

  end

end
