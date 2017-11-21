class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :responses, class_name: "Reply",
           foreign_key: "parent_id"

  belongs_to :parent, class_name: "Reply", optional: true

  validates_presence_of :text
  validates_presence_of :title

  # Need to have a function to get all the replies with
  # a given post_id
  def self.get_by_post_id(id)
    Reply.where(post_id: id, parent_id: 0)
  end
end
