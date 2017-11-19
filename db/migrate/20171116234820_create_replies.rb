class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies do |t|
      t.references :user, foreign_key: true
      t.references :parent, index: true
      t.references :post, foreign_key: true
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
