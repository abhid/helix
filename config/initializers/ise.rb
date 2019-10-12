$mnt = Isepick::IseMNT.new(Rails.configuration.ise["mnt_ip"], Rails.configuration.ise["ise_username"], Rails.configuration.ise["ise_password"])
$ers = Isepick::IseERS.new(Rails.configuration.ise["pan_ip"], Rails.configuration.ise["ise_username"], Rails.configuration.ise["ise_password"])
