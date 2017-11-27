class Post < ApplicationRecord
  belongs_to :user
  has_many :unread_posts, dependent: :destroy
  has_many :replies, dependent: :destroy

  validates_presence_of :text
  validates_presence_of :title

  self.per_page = 8

end
