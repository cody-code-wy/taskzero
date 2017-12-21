json.extract! task, :id, :name, :kind, :description, :deferred_date, :delegate, :delegate_note, :complete, :project_id, :context_id, :user_id, :created_at, :updated_at
json.url task_url(task, format: :json)
