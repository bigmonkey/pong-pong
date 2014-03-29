class AddAttachmentSize160x600ToBanners < ActiveRecord::Migration
  def change
			add_attachment :banners, :size_160x600
  end
end
