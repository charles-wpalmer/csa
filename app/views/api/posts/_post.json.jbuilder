json.extract! post, :id, :user_id, :post_count, :title, :text, :anonymous, :created_at, :updated_at
json.url api_post_url(post, format: :json)
