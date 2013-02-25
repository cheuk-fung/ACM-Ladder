require 'net/http'
require 'open-uri'

# TODO: handles errors
class POJ
  BaseURL = "http://poj.org"
  Handle = ENV['POJ_HANDLE']
  Password = ENV['POJ_PASSWORD']
  Languages = { "C++" => 0, "C" => 1, "Java" => 2, "Pascal" => 3 }

  def submit(submission)
    uri = URI(BaseURL)
    language = Languages[ApplicationController.helpers.language_list.invert[submission.language]]
    Net::HTTP.start(uri.host, uri.port) do |http|
      uri = URI("#{BaseURL}/login")
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({ 'user_id1' => Handle, 'password1' => Password })
      response = http.request(request)
      cookies = response.response['set-cookie']

      uri = URI("#{BaseURL}/submit")
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Cookie'] = cookies
      request.set_form_data({ 'problem_id' => submission.problem.original_id,
                              'language' => language,
                              'source' => submission.code })
      response = http.request(request)
    end
  end

  def fetch_problem(problem)
    return if problem.original_id.nil?

    doc = Hpricot(open(url = "#{BaseURL}/problem?id=#{problem.original_id}"))

    result = doc.at("div.ptt")
    return if result.nil?
    problem.title = result.inner_html

    result = doc/"div.plm td"
    problem.time_limit = result[0].inner_html[/\d+/]
    problem.memory_limit = result[2].inner_html[/\d+/]

    result = doc/"div.ptx"
    problem.description = result[0].inner_html.sub('<img src="', '<img src="http://poj.org/')
    problem.input = result[1].inner_html.sub('<img src="', '<img src="http://poj.org/')
    problem.output = result[2].inner_html.sub('<img src="', '<img src="http://poj.org/')
    problem.hint = result[3].inner_html.sub('<img src="', '<img src="http://poj.org/') if doc.search("p.pst").inner_html.include?("Hint")

    result = doc/"pre.sio"
    problem.sample_input = result[0].inner_html
    problem.sample_output = result[1].inner_html
  end

  def fetch_status(submission)
    while submission.status <= 2 # waiting, compiling or running
      doc = Hpricot(open("#{BaseURL}/status?problem_id=#{submission.problem.original_id}&user_id=#{Handle}"))
      result = doc.search("table")[4].search("tr")[1].search("td")

      submission.original_id ||= result[0].inner_html

      status = result[3].at("font").inner_html
      submission.status = ApplicationController.helpers.status_list[status =~ /Running/ ? "Running" : status]
      if status == "Accepted"
        submission.memory = result[4].inner_html[/\d+/]
        submission.time = result[5].inner_html[/\d+/]
      elsif status == "Compile Error"
        doc = Hpricot(open("#{BaseURL}/showcompileinfo?solution_id=#{submission.original_id}"))
        submission.error = doc.at("pre").inner_html
      end

      submission.save
    end
  end
end
