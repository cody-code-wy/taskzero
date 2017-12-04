json.extract! project, :id, :name, :user_id, :kind, :on_hold, :created_at, :updated_at
json.url project_url(project, format: :json)
