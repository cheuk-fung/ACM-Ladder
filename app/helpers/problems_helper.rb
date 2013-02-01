module ProblemsHelper
  def source_list
    ["POJ", "NKOJ"]
  end

  def show_user_status(problem)
    if user_signed_in?
      submissions = current_user.submissions.where(:problem_id => problem.id)
      return "Submit Now" if submissions.empty?
      return "Accepted" unless submissions.where(:status => status_list["Accepted"]).empty?
      return "Finish it"
    else
      return "Log in now"
    end
  end
end
