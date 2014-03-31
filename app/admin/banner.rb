ActiveAdmin.register Banner do
#  actions :all, except: :new

  permit_params   :name,
                  :rotation_rank,
                  :size_160x600,
                  :partner_id,
                  :lender_link,
                  :lender_tail

  index do
    column :name
    column :image do |b| link_to(image_tag(b.size_160x600.url(:thumb)), admin_banner_path(b.id)) end
    column :partner
    column :rotation_rank
    default_actions
  end

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
    f.inputs "Choose #{params[:lender_type].titleize} Lender Name"do
      f.input :lender_type, as: :hidden,  input_html: { value: params[:lender_type]}

      case params[:lender_type]
        when "payday"
          f.input :name, as: :select, collection: PaydayLoan.all
        #when 'advertiser'
        #  f.input :name, as: :select, collection: Advertiser.all  
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
      #binding.pry
      #Assign lender
      case params[:banner][:lender_type]
      when "payday"
        lender = PaydayLoan.find(params[:banner][:name])        
      #when 'advertiser'
      #  lender = Advertiser.find(params[:banner][:name])
      else "term"
        lender = TermLoan.find(params[:banner][:name])
      end      
      
      banner_name = lender.name + " 160x600"
      
      #create a new Partner
      partner = Partner.new
      partner.name = banner_name
      partner.lender_link = params[:banner][:lender_link]
      partner.lender_tail = params[:banner][:lender_tail]
      partner.save

      #create a new Banner instance
      params[:banner][:name]=banner_name
      params[:banner][:partner_id] = partner.id.to_s
      binding.pry
      @banner = lender.banners.create!
  
    end
  end
end
