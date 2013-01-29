module SubmissionsHelper
  def status_list
    [ "Waiting",
      "Running",
      "Accepted",
      "Presentation Error",
      "Time Limit Exceeded",
      "Memory Limit Exceeded",
      "Wrong Answer",
      "Runtime Error",
      "Output Limit Exceeded",
      "Function Limit Exceeded",
      "Compile Error",
      "System Error" ]
  end
end
