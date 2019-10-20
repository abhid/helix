class Session < ApplicationRecord
  before_save :normalize_mac

  private
  def normalize_mac
    self.mac_text = mac.gsub(":", "").upcase
  end
end
