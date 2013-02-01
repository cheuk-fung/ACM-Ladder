class ProblemsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    @problem.fetch_remote

    if @problem.save
      redirect_to problems_url, :notice => "Problem was successfully created."
    else
      flash[:alert] = "Failed to create problem."
      render :action => "new"
    end
  end

  def show
  end
end
