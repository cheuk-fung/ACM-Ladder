class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  attr_accessible :code, :language, :memory, :original_id, :status, :time
end
