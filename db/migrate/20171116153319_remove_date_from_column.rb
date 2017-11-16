class RemoveDateFromColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :date
  end
end
