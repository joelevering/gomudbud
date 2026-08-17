json.extract! npc, :id, :room_id, :name, :description, :class_name, :level, :exp, :created_at, :updated_at
json.url npc_url(npc, format: :json)
