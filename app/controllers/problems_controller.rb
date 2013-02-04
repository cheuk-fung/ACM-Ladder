class ProblemsController < ApplicationController
  load_and_authorize_resource

  def index
    @user_level = user_signed_in? ? current_user.level : 0
    params[:level] ||= @user_level
    begin
      @current_level = Integer(params[:level])
      if @current_level < 0
        flash[:alert] = "Kidding? The level you tell me is negative!"
        @current_level = @user_level
      elsif @current_level > @user_level
        flash[:alert] = "Oops, you haven't reach level #{@current_level} yet...."
        @current_level = @user_level
      end
    rescue ArgumentError
      flash[:alert] = "Kidding? The level you tell me is not a number!"
      @current_level = @user_level
    end
    @problems = Problem.where(:level => @current_level)
  end

  def new
  end

  def create
    @problem.fetch_remote

    if @problem.save
      redirect_to problem_path(@problem), :notice => "Problem was successfully created."
    else
      flash[:alert] = "Failed to create problem."
      render :action => :new
    end
  end

  def edit
  end

  def update
    @problem.level = params[:problem][:level]

    if @problem.save
      redirect_to problem_path(@problem), :notice => "Problem was successfully updated."
    else
      flash[:alert] = "Failed to edit problem."
      render :action => :edit
    end
  end

  def show
    user_level = user_signed_in? ? current_user.level : 0
    if user_level < @problem.level
      redirect_to problems_path, :alert => "Oops, you are not powerful enough to view this problem...."
    end
  end
end
