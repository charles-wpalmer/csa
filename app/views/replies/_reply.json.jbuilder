json.extract! reply, :id, :author, :date, :under, :thread, :title, :text, :created_at, :updated_at
json.url reply_url(reply, format: :json)
