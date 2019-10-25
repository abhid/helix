class Setting < ApplicationRecord
  def self.[](namespace)
    Setting.find_by(namespace: namespace)
  end
  def self.[] = (namespace, value)
    setting = Setting.find_by(namespace: namespace)
    setting.hash = value
    setting.save
  end
  def <<(x)
    self.hash << x
    self.save
    return self
  end
end
