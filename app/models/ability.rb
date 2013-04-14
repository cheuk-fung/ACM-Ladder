class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:user)
      can :read, :all
      cannot :show, Setting

      can :create, Submission
      can :update, Submission
    else
      can :read, :all
      cannot :show, [Submission, Setting]
    end
  end
end
