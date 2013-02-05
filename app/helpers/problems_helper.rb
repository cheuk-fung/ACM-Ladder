module ProblemsHelper
  def show_problem_status(status)
    case status
    when :accepted then '<i class="icon-ok"></i>'.html_safe
    when :failed then '<i class="icon-remove"></i>'.html_safe
    when :unopened then '<i class="icon-minus"></i>'.html_safe
    else '<i class="icon-lock"></i>'.html_safe
    end
  end
end
