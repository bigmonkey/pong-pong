class Banner < ActiveRecord::Base
  attr_accessor :lender_type, :lender_link, :lender_tail 
  belongs_to :partner
	belongs_to :bannerable, polymorphic: true

  has_attached_file :size_160x600, styles: { thumb: '16x60'},
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
              
	validates :partner_id, presence: true
  validates :partner_id, uniqueness: true  
  validates_attachment_content_type :size_160x600, :content_type => /\Aimage\/.*\Z/

  def s3_credentials
    {
      :bucket => ENV['AWS_BUCKET'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
		}
  end  

end
