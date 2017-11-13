class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :author
      t.time :date
      t.integer :post_count
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
