class UsersController < ApplicationController
  load_and_authorize_resource :find_by => :handle

  def show
    @solved = @user.submissions.where(:status => OJ::StatusSymToID[:ac]).uniq.pluck(:problem_id)
    if @solved.empty?
      @failed = @user.submissions.select(:problem_id).uniq.pluck(:problem_id)
    else
      @failed = @user.submissions.where("`problem_id` NOT IN (?)", @solved).uniq.pluck(:problem_id)
    end
    @submitted = @user.submissions.pluck(:problem_id)
  end
end
