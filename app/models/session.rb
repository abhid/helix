class Session < ApplicationRecord
  before_save :normalize_mac

  def oui
    Oui.where("oui = trunc('#{mac}'::macaddr)").first
  end

  private
  def normalize_mac
    self.mac_text = mac.gsub(":", "").upcase
  end
end
