class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_level_up

  rescue_from CanCan::AccessDenied do |exception|
    if exception.action == :new && exception.subject.class == Submission
      redirect_to new_user_session_path, :alert => "You need to sign in or sign up before continuing."
    else
      redirect_to root_path, :alert => exception.message
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:level] = current_user.level
    stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)
  end

  private

  def check_level_up
    if user_signed_in?
      session[:level] ||= current_user.level
      if current_user.level > session[:level]
        flash[:info] = "Congratulations! You got level up!"
        session[:level] = current_user.level
      end
    end
  end
end
