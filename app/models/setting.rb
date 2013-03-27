class Setting < ActiveRecord::Base
  attr_accessible :key, :value

  def self.update_exp
    max_level = Setting.find_by_key("MAX_LEVEL").value.to_i
    (max_level + 1).times { |level|
      Setting.find_by_key("EXP_L#{level}") { |s|
        s.value = (Problem.where("`level` <= ?", level).sum(:exp) * 3.0 / 4).ceil
      }.save
    }
  end
end
