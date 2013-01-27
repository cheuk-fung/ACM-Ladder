class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  attr_accessible :code, :language
  validates_presence_of :problem_id, :code, :language # :user_id

  def submit!
    case self.problem.source
    when "POJ"
      submit_poj
    when "NKOJ"
      submit_nkoj
    end
  end
  handle_asynchronously :submit!, :queue => "submit"

  private

  def submit_poj
    # Submit to POJ and keep checking status until judgement finishes.
    # Current local submission is bound to the last remote submission,
    # so this method can't run in parallel.
  end
end
