class ProblemsController < ApplicationController
  def index
    @problems = Problem.all
  end

  def new
    @problem = Problem.new
  end

  def create
    @problem = Problem.new(params[:problem])

    if @problem.save
      redirect_to problems_url, :notice => "Problem was successfully created."
    else
      flash[:alert] = "Failed to create problem."
      render :action => "new"
    end
  end
end
