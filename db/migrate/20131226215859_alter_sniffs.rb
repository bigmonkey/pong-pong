class AlterSniffs < ActiveRecord::Migration
  def change
  	add_column("sniffs", "sniff_score", :integer)
  end
end
