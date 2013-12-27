class AlterSniffs < ActiveRecord::Migration
  def change
  	add_column("sniffs", "sniff_rank", :integer)
  end
end
