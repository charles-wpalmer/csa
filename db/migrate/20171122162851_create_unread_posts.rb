class CreateUnreadPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :unread_posts do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.integer :unread

      t.timestamps
    end
  end
end
