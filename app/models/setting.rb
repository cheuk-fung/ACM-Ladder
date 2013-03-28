class Setting < ActiveRecord::Base
  attr_accessible :key, :value

  def self.update_exp
    max_level = Setting.find_by_key("MAX_LEVEL").value.to_i
    max_level.times do |level|
      Setting.find_by_key("EXP_L#{level}") do |s|
        s.value = (Problem.where(:level => 0..level).sum(:exp) * 3.0 / 4).ceil
      end.save
    end
    Setting.find_by_key("EXP_L#{max_level}") do |s|
      s.value = Problem.where(:level => 0..max_level).sum(:exp)
    end.save
  end
end
