begin
  $ib_ctx = Infoblox::Connection.new(username: Setting["infoblox"]["username"], password: Setting["infoblox"]["password"], host: Setting["infoblox"]["server"], ssl_opts: {verify: false})
rescue
end
