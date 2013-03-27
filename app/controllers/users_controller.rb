class UsersController < ApplicationController
  load_and_authorize_resource :find_by => :handle

  def show
    @solved = @user.submissions.where(:status => OJ::StatusDict["Accepted"]).uniq.pluck(:problem_id)
    @failed = @user.submissions.where("`problem_id` NOT IN (?)", @solved).uniq.pluck(:problem_id)
    @submitted = @user.submissions.pluck(:problem_id)
  end
end
