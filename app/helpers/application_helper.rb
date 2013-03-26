module ApplicationHelper
  def get_announcement
    Setting.where(:key => "ANNOUNCEMENT").last.value
  end
end
