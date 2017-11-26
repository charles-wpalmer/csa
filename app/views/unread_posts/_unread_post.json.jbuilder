json.extract! unread_post, :id, :user_id, :post_id, :unread, :created_at, :updated_at
json.url unread_post_url(unread_post, format: :json)
