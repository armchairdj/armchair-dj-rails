json.extract! category, :id, :name, :format, :allow_multiple, :created_at, :updated_at
json.url admin_category_url(category, format: :json)