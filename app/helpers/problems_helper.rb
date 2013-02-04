module ProblemsHelper
  def show_user_status(problem)
    if user_signed_in?
      submissions = current_user.submissions.where(:problem_id => problem.id)
      return '<i class="icon-minus"></i>'.html_safe if submissions.empty?
      return '<i class="icon-ok"></i>'.html_safe unless submissions.where(:status => status_list["Accepted"]).empty?
      return '<i class="icon-remove"></i>'.html_safe
    else
      return '<i class="icon-lock"></i>'.html_safe
    end
  end
end
