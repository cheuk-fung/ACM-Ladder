class UsersController < ApplicationController
  load_and_authorize_resource :find_by => :handle

  def index
    params[:page] ||= 1
    begin
      @current_page = Integer(params[:page])
      if @current_page < 1
        flash[:alert] = "Kidding? The page you tell me is non-positive!"
        @current_page = 1
      end
    rescue ArgumentError
      flash[:alert] = "Kidding? The page you tell me is not a number!"
      @current_page = 1
    end

    if params[:rankings].nil? || params[:rankings][:toggle_finished] == '0'
      @users = User.where(:level => 0..Setting.find_by_key("MAX_LEVEL").value.to_i)
    end
    @submitted = {}
    @users.each { |user| @submitted[user] = user.submissions.count }
    @users.sort! do |x, y|
      if x.exp != y.exp
        y.exp <=> x.exp
      else
        @submitted[x] <=> @submitted[y]
      end
    end
    @users = @users[(@current_page - 1) * 10..@current_page * 10] || []
  end

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
