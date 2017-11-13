json.extract! post, :id, :id, :author, :date, :post_count, :title, :text, :created_at, :updated_at
json.url post_url(post, format: :json)
