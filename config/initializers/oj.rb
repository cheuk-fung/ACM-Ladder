module OJ
  SourceList = ["POJ", "NKOJ"]

  LanguageID = { :c => 0, :cpp => 1, :java => 2, :pascal => 3 }
  LanguageSymbol = LanguageID.invert
  lid = LanguageID
  LanguageName = { lid[:c] => "C", lid[:cpp] => "C++", lid[:java] => "Java", lid[:pascal] => "Pascal" }

  StatusSymToID = {
    :wait	=> 0,
    :comp	=> 1,
    :run	=> 2,
    :ac		=> 3,
    :pe		=> 4,
    :tle	=> 5,
    :mle	=> 6,
    :wa		=> 7,
    :re		=> 8,
    :ole	=> 9,
    :fle	=> 10,
    :ce		=> 11,
    :se		=> 12
  }
  StatusIDToSym = StatusSymToID.invert
  StatusSymToName = {
    :wait	=> "Waiting",
    :comp	=> "Compiling",
    :run	=> "Running",
    :ac		=> "Accepted",
    :pe		=> "Presentation Error",
    :tle	=> "Time Limit Exceeded",
    :mle	=> "Memory Limit Exceeded",
    :wa		=> "Wrong Answer",
    :re		=> "Runtime Error",
    :ole	=> "Output Limit Exceeded",
    :fle	=> "Function Limit Exceeded",
    :ce		=> "Compile Error",
    :se		=> "System Error"
  }
  StatusNameToSym = StatusSymToName.invert
  StatusIDToName = {
    StatusSymToID[:wait]	=> StatusSymToName[:wait],
    StatusSymToID[:comp]	=> StatusSymToName[:comp],
    StatusSymToID[:run]		=> StatusSymToName[:run],
    StatusSymToID[:ac]		=> StatusSymToName[:ac],
    StatusSymToID[:pe]		=> StatusSymToName[:pe],
    StatusSymToID[:tle]		=> StatusSymToName[:tle],
    StatusSymToID[:mle]		=> StatusSymToName[:mle],
    StatusSymToID[:wa]		=> StatusSymToName[:wa],
    StatusSymToID[:re]		=> StatusSymToName[:re],
    StatusSymToID[:ole]		=> StatusSymToName[:ole],
    StatusSymToID[:fle]		=> StatusSymToName[:fle],
    StatusSymToID[:ce]		=> StatusSymToName[:ce],
    StatusSymToID[:se]		=> StatusSymToName[:se]
  }
  StatusNameToID = StatusIDToName.invert

  class << self
    def fetch(problem)
      return if problem.original_id.nil?

      case problem.source
      when "POJ"
        POJ.fetch(problem)
      when "NKOJ"
        NKOJ.fetch(problem)
      end
    end

    def submit(submission)
      # Submit to remote OJ and keep checking status until judgement finishes.
      # Current local submission is bound to the last remote submission,
      # so this method can't run in parallel.

      case submission.problem.source
      when "POJ"
        POJ.submit(submission)
      when "NKOJ"
        NKOJ.submit(submission)
      end

      current_user = submission.user
      accepted = StatusSymToID[:ac]
      count = current_user.submissions.where(:problem_id => submission.problem, :status => accepted).count
      if submission.status == accepted && count == 1
        current_user.add_exp(submission.problem.exp)
        current_user.level_up
      end
    end
    # handle_asynchronously :submit, :queue => "submit"

    def language_collection(problem)
      case problem.source
      when "POJ"
        POJ::LanguageDict
      when "NKOJ"
        NKOJ::LanguageDict
      end
    end
  end
end

require 'oj/poj'
require 'oj/nkoj'
