json.extract! reply, :id, :user_id, :parent, :post_id, :title, :text, :created_at, :updated_at
json.url reply_url(reply, format: :json)
