class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    if exception.action == :new && exception.subject.class == Submission
      redirect_to new_user_session_path, :alert => "You need to sign in or sign up before continuing."
    else
      redirect_to root_path, :alert => exception.message
    end
  end
end
