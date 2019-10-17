$prime = Faraday.new("https://#{Rails.configuration.prime["prime_ip"]}/webacs/api/v4/data/") do |conn|
  conn.basic_auth(Rails.configuration.prime["prime_username"], Rails.configuration.prime["prime_password"])
  conn.adapter Faraday.default_adapter
  conn.ssl[:verify] = false
end
