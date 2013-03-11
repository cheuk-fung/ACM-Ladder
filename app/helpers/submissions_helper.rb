module SubmissionsHelper
  def get_submission_status(status)
    case status
    when "Waiting" then ""
    when "Compiling", "Running" then "info"
    when "Accepted" then "success"
    when "Compile Error", "System Error" then "warning"
    else "important"
    end
  end
end
