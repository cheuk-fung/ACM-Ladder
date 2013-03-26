module SettingsHelper
  def get_max_level
    Setting.find_by_key("MAX_LEVEL").value.to_i
  end

  def get_max_difficulty
    Setting.find_by_key("MAX_DIFFICULTY").value.to_i
  end

  def show_announcement
    Setting.find_by_key("SHOW_ANNOUNCEMENT").value == "1"
  end

  def get_announcement
    Setting.where(:key => "ANNOUNCEMENT").last.value
  end
end
