json.array!(@sensors) do |sensor|
  json.extract! sensor, :id, :sensor_id, :cleared, :cleared_at
  json.url sensor_url(sensor, format: :json)
end
