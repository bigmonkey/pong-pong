class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string "word"
      t.string "meta_title_phrase" #plural version of keyword for copy in index and show for term_loans and payday_loans
      t.string "slug"
      t.string "category"
      t.text "article"
      t.string "parent_page"
      t.string "controller"
      t.string "created_at"
      t.string "updated_at"
      t.timestamps
    end
  end
end
