class SubmissionsController < ApplicationController
  def index
    @submissions = Submission.all
  end

  def new
    @problem = Problem.find(params[:problem_id])
    @submission = Submission.new
  end

  def create
    @problem = Problem.find(params[:problem_id])
    @submission = Submission.new(params[:submission])
    @submission.problem = @problem

    if @submission.save
      redirect_to submissions_url, :notice => "Submit successfully."
    else
      render :action => "new"
    end
  end
end
