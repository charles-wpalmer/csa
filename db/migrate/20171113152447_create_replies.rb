class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies do |t|
      t.integer :author
      t.time :date
      t.integer :under
      t.integer :thread
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
