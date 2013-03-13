class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  attr_accessible :code, :language
  validates_presence_of :user_id, :problem_id, :code, :language
end
