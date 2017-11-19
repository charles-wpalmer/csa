class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.integer :post_count
      t.string :title
      t.text :text
      t.boolean :anonymous

      t.timestamps
    end
  end
end
