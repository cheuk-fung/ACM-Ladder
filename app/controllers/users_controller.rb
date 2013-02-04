class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def level_up
    if current_user.level >= Integer(ENV['MAX_LEVEL'])
      redirect_to problems_path, :notice => "Hey, you have already reached the top level!"
    elsif current_user.level_up
      redirect_to problems_path, :notice => "Congratulations! You got level up!"
    else
      redirect_to problems_path, :alert => "Want to level up? Please solve all problems in this level."
    end
  end
end
