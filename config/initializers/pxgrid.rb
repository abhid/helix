begin
  $pxgrid = Pxgrid::Client.new(Setting["ise"]["pan"], "isebox", {username: Setting["ise"]["pxgrid_username"], password: Setting["ise"]["pxgrid_password"]})
rescue
end
