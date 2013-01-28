module SubmissionsHelper
  def language_list
    { "C" => 0, "C++" => 1, "Java" => 2, "Pascal" => 3 }
  end

  def status_list
    [
      "Waiting",
      "Accepted",
      "Presentation Error",
      "Time Limit Exceeded",
      "Memory Limit Exceeded",
      "Wrong Answer",
      "Runtime Error",
      "Output Limit Exceeded",
      "Compile Error",
      "System Error"
    ]
  end
end
