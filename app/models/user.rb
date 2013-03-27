class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :async

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :college, :handle, :level, :major, :mobile, :school, :student_id
  validates_presence_of :handle
  validates_uniqueness_of :handle

  has_many :submissions

  after_create :assign_default_role

  # Change route from id to handle
  def to_param
    handle
  end

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login
  attr_accessible :login

  # Overriding the following method for authenticating by either username of email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(handle) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def add_exp(exp)
    self.exp += exp
    self.save
  end

  def level_up
    max_level = Setting.find_by_key("MAX_LEVEL").value.to_i
    level = self.level
    level += 1 while level <= max_level && self.exp >= Setting.find_by_key("EXP_L#{level}").value.to_i
    if level > self.level
      self.level = level
      self.save
    end
  end

  def recalc_exp
    accepted = OJ::StatusDict["Accepted"]
    exp = 0
    submissions.where(:status => accepted).select(:problem_id).uniq.each { |submission| exp += submission.problem.exp }
    self.exp = exp
    self.save

    self.level_up
  end

  private

  def assign_default_role
    add_role :user
  end
end
