class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :user
      can :read, :all
      can :create, Submission
      can :level_up, User
    else
      can :read, :all
    end
  end
end
