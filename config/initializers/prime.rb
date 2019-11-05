begin
  $prime = Faraday.new("https://#{Setting["prime"]["server"]}/webacs/api/v4/data/") do |conn|
    conn.basic_auth(Setting["prime"]["username"], Setting["prime"]["password"])
    conn.adapter Faraday.default_adapter
    conn.ssl[:verify] = false
  end
rescue
end
