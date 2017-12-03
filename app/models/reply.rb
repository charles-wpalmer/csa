class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # Self referential model
  has_many :responses, class_name: "Reply",
           foreign_key: "parent_id"

  belongs_to :parent, class_name: "Reply", optional: true

  # Function to get all the replies by
  # a given post_id, and where they are
  # the top level reply
  def self.get_by_post_id(id)
    Reply.where(post_id: id, parent_id: 0)
  end

  # Function to get all the replies for a post after
  # a certain date/time - used for unread_posts
  # Wanted to seperate this out of the posts_helper
  def self.get_last_access(post, last_access, user_id)
    Reply.where('created_at > ? AND post_id = ? AND user_id != ?',
                last_access,
                post,
                user_id
    )
  end
end
