class UsersController < ApplicationController
  load_and_authorize_resource :find_by => :handle

  def show
    @solved = @user.submissions.where(:status => ApplicationController.helpers.status_list["Accepted"]).uniq.pluck(:problem_id)
    @failed = @user.submissions.where("`problem_id` NOT IN (?)", @solved).uniq.pluck(:problem_id)
    @submitted = @user.submissions.pluck(:problem_id)
  end

  def level_up
    if current_user.level >= Integer(ENV['MAX_LEVEL'])
      redirect_to problems_path, :notice => "Hey, you have already reached the top level!"
    elsif current_user.level_up
      redirect_to problems_path, :notice => "Congratulations! You got level up!"
    else
      redirect_to problems_path, :alert => "Want to level up? Please solve all problems in this level."
    end
  end
end
