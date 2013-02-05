class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :college, :handle, :level, :major, :mobile, :school, :student_id
  validates_presence_of :handle
  validates_uniqueness_of :handle

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  attr_accessible :login

  has_many :submissions

  after_create :assign_default_role

  # Overriding the following method for authenticating by either username of email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(handle) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def level_up
    accepted = ApplicationController.helpers.status_list["Accepted"]
    problem_count = Problem.where(:level => self.level).count
    solved_count = submissions.joins(:problem).select('`problems`.`id`').where(:problems => { :level => self.level }, :status => accepted).count(:distinct => true)
    if solved_count == problem_count
      self.level += 1
      self.save
    else
      nil
    end
  end

  private

  def assign_default_role
    add_role :user
  end
end
