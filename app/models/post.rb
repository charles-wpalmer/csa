class Post < ApplicationRecord
  belongs_to :user

  has_many :replies

  self.per_page = 8

  # Add one to the post count, after a reply has been
  # added for a post
  def self.add_to_post_count(post)
    post = Post.find(post)
    post.post_count += 1
    post.save
  end
end
