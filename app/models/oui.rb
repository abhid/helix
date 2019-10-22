class Oui < ApplicationRecord
  def self.find_by_mac(mac)
    oui = Oui.where("oui = trunc('#{mac}'::macaddr)").first
    oui = Oui.new(vendor: "Unknown") unless oui
    return oui
  end
end
