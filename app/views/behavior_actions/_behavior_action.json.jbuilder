json.extract! behavior_action, :id, :behavior_id, :action, :payload, :created_at, :updated_at
json.url behavior_action_url(behavior_action.behavior, behavior_action, format: :json)
