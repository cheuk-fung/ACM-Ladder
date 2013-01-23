class ProblemsController < ApplicationController
  def index
    @problems = Problem.all
  end

  def new
    @problem = Problem.new
  end
end
