class User < ActiveRecord::Base
  has_many :submissions
  attr_accessible :college, :handle, :level, :major, :mobile, :school, :student_id
end
