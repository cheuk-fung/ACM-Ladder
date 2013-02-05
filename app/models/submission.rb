require 'oj/poj'

class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  attr_accessible :code, :language
  validates_presence_of :user_id, :problem_id, :code, :language

  def submit
    # Submit to remote OJ and keep checking status until judgement finishes.
    # Current local submission is bound to the last remote submission,
    # so this method can't run in parallel.
    #
    case self.problem.source
    when "POJ"
      submit_poj
    when "NKOJ"
      submit_nkoj
    end
  end
  handle_asynchronously :submit, :queue => "submit"

  private

  def submit_poj
    oj = POJ.new(self)
    oj.submit
    sleep 1
    oj.fetch_status
  end
end
