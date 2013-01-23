class Problem < ActiveRecord::Base
  attr_accessible :description, :hint, :input, :level, :memory_limit, :original_id, :output, :sample_input, :sample_output, :source, :time_limit, :title
  validates_presence_of :description, :input, :level, :memory_limit, :original_id, :output, :sample_input, :sample_output, :source, :time_limit, :title
end
