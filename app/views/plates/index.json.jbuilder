json.array!(@plates) do |plate|
  json.extract! plate, :id, :desc
  json.url plate_url(plate, format: :json)
end
