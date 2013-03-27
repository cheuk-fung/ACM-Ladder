module ApplicationHelper
  def get_alert_class(key)
    case key
    when :notice then "success"
    when :info then "info"
    else "error"
    end
  end
end
