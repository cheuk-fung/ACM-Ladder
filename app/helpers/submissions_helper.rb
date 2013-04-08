module SubmissionsHelper
  def get_submission_status(status)
    case status
    when :wait then ""
    when :comp, :run then "info"
    when :ac then "success"
    when :ce, :se then "warning"
    else "important"
    end
  end
end
