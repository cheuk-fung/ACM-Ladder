class SubmissionsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @problem = Problem.find(params[:problem_id])
  end

  def create
    @problem = Problem.find(params[:problem_id])
    @submission.problem = @problem
    @submission.user = current_user

    if @submission.save
      @submission.submit	# delayed job
      redirect_to submissions_url, :notice => "Submit successfully."
    else
      flash[:alert] = "Failed to submit."
      render :action => :new
    end
  end
end
