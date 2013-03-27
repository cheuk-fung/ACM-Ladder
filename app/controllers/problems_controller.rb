class ProblemsController < ApplicationController
  load_and_authorize_resource

  def index
    max_level = Setting.find_by_key("MAX_LEVEL").value.to_i
    @user_level = user_signed_in? ? (current_user.has_role?(:admin) ? max_level : current_user.level) : 0
    params[:level] ||= @user_level
    begin
      @current_level = Integer(params[:level])
      if @current_level < 0
        if !(@current_level == -1 && current_user.has_role?(:admin))
          flash[:alert] = "Kidding? The level you tell me is negative!"
          @current_level = @user_level
        end
      elsif @current_level > max_level && @user_level > max_level
        @congratulations = true
      elsif @current_level > @user_level
        flash[:alert] = "Oops, you haven't reach level #{@current_level} yet...."
        @current_level = @user_level
      end
    rescue ArgumentError
      flash[:alert] = "Kidding? The level you tell me is not a number!"
      @current_level = @user_level
    end
    @problems = Problem.where(:level => @current_level).all

    @status = []
    if user_signed_in?
      accepted = OJ::StatusDict["Accepted"]
      accepted_status = current_user.submissions.where(:problem_id => @problems, :status => accepted).select(:problem_id).uniq
      accepted_status.each { |submission| @status[submission.problem_id] = :accepted }
      opened_status = current_user.submissions.where(:problem_id => @problems).select(:problem_id).uniq
      opened_status.each { |submission| @status[submission.problem_id] ||= :failed }
      @problems.each { |problem| @status[problem.id] ||= :unopened }
    end
  end

  def new
  end

  def create
    @problem.exp = 1 << @problem.exp
    OJ.fetch(@problem)

    if @problem.save
      Setting.update_exp
      redirect_to problem_path(@problem), :notice => "Problem was successfully created."
    else
      flash[:alert] = "Failed to create problem."
      render :action => :new
    end
  end

  def edit
    @problem.exp = Integer(Math.log2(@problem.exp))
  end

  def update
    @problem.level = params[:problem][:level]
    @problem.exp = 1 << params[:problem][:exp].to_i

    if @problem.save
      Setting.update_exp
      redirect_to problem_path(@problem), :notice => "Problem was successfully updated."
    else
      flash[:alert] = "Failed to edit problem."
      render :action => :edit
    end
  end

  def show
    user_level = user_signed_in? ? (current_user.has_role?(:admin) ? @problem.level : current_user.level) : 0
    if user_level < @problem.level
      redirect_to problems_path, :alert => "Oops, you are not powerful enough to view this problem...."
    end
  end
end
