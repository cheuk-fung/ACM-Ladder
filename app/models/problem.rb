require 'oj/poj'
require 'oj/nkoj'

class Problem < ActiveRecord::Base
  has_many :submissions
  attr_accessible :level, :original_id, :source
  validates_presence_of :description, :input, :level, :memory_limit, :original_id, :output, :sample_input, :sample_output, :source, :time_limit, :title

  def fetch_remote
    return if self.original_id.nil?

    case self.source
    when "POJ"
      POJ.new.fetch_problem(self)
    when "NKOJ"
      NKOJ.new.fetch_problem(self)
    end
  end
end
