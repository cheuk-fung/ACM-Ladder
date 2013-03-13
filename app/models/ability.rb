class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:user)
      can :read, :all
      can [:create, :compile_error, :show_code], Submission
      can :level_up, User
    else
      can :read, :all
      cannot :show, Submission
    end
  end
end
