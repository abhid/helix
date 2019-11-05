class Setting < ApplicationRecord
  def self.[](namespace)
    setting = Setting.find_by(namespace: namespace)
    setting ? setting.value : nil
  end
  def self.[]=(namespace, value)
    setting = Setting.find_or_initialize_by(namespace: namespace)
    setting.value = value
    setting.save
  end
  def <<(x)
    self.hash << x
    self.save
    return self
  end
end
