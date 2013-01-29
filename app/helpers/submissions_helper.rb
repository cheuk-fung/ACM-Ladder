module SubmissionsHelper
  def status_list
    { "Waiting"			=> 0,
      "Compiling"		=> 1,
      "Running"			=> 2,
      "Accepted"		=> 3,
      "Presentation Error"	=> 4,
      "Time Limit Exceeded"	=> 5,
      "Memory Limit Exceeded"	=> 6,
      "Wrong Answer"		=> 7,
      "Runtime Error"		=> 8,
      "Output Limit Exceeded"	=> 9,
      "Function Limit Exceeded"	=> 10,
      "Compile Error"		=> 11,
      "System Error"		=> 12 }
  end
end
