class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
   		t.integer	:partner_id
      t.string :name   
      t.decimal	:rotation_rank
      t.references :bannerable, polymorphic: true
      t.timestamps
    end
  end
end
