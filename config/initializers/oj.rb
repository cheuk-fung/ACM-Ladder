module OJ
  SourceList = ["POJ", "NKOJ"]

  LanguageID = { :c => 0, :cpp => 1, :java => 2, :pascal => 3 }
  LanguageSymbol = LanguageID.invert

  lid = LanguageID
  LanguageName = { lid[:c] => "C", lid[:cpp] => "C++", lid[:java] => "Java", lid[:pascal] => "Pascal" }

  StatusDict = {
    "Waiting"			=> 0,
    "Compiling"			=> 1,
    "Running"			=> 2,
    "Accepted"			=> 3,
    "Presentation Error"	=> 4,
    "Time Limit Exceeded"	=> 5,
    "Memory Limit Exceeded"	=> 6,
    "Wrong Answer"		=> 7,
    "Runtime Error"		=> 8,
    "Output Limit Exceeded"	=> 9,
    "Function Limit Exceeded"	=> 10,
    "Compile Error"		=> 11,
    "System Error"		=> 12
  }
  StatusName = StatusDict.invert

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
    end
    handle_asynchronously :submit, :queue => "submit"
  end
end

require 'oj/poj'
require 'oj/nkoj'
