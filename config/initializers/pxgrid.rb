$pxgrid = Pxgrid::Client.new(Rails.configuration.ise["pan_ip"], "isebox", {username: Rails.configuration.ise["pxgrid_username"], password: Rails.configuration.ise["pxgrid_password"]})
