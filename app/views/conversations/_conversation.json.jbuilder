json.extract! conversation, :id, :title, :subject, :created_at, :updated_at
json.url conversation_url(conversation, format: :json)
