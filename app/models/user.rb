class User < ActiveRecord::Base
  attr_accessible :college, :handle, :level, :major, :mobile, :school, :student_id
end
