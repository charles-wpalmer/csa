class UnreadPost < ApplicationRecord
  belongs_to :user
  belongs_to :post

  def self.update_record(post_id, user_id)
    unread = UnreadPost.where(post_id: post_id, user_id: user_id)

    # If there isn't already a record for this post and user, create one
    if unread.count == 0
      UnreadPost.new do |u|
        u.post_id = post_id
        u.user_id = user_id
        u.save
      end
    else
      # If there is a record, update its updated_at to current time
      unread.update(
          updated_at: Time.new
      )
    end
  end
end
