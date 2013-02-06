require 'net/http'
require 'open-uri'

# TODO: handles errors
class POJ
  BaseURL = "http://poj.org"
  LoginURL = "#{BaseURL}/login"
  SubmitURL = "#{BaseURL}/submit"
  Handle = ENV['POJ_HANDLE']
  Password = ENV['POJ_PASSWORD']
  Languages = { "C++" => 0, "C" => 1, "Java" => 2, "Pascal" => 3 }

  def initialize(s)
    @submission = s
    @status_url = "#{BaseURL}/status?problem_id=#{s.problem.original_id}&user_id=#{Handle}"
    @language = Languages[ApplicationController.helpers.language_list.invert[s.language]]
  end

  def submit
    uri = URI(BaseURL)
    Net::HTTP.start(uri.host, uri.port) do |http|
      uri = URI(LoginURL)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({ 'user_id1' => Handle, 'password1' => Password })
      response = http.request(request)
      cookies = response.response['set-cookie']

      uri = URI(SubmitURL)
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Cookie'] = cookies
      request.set_form_data({ 'problem_id' => @submission.problem.original_id,
                              'language' => @language,
                              'source' => @submission.code })
      response = http.request(request)
    end
  end

  def fetch_status
    while @submission.status <= 2 # waiting, compiling or running
      doc = Hpricot(open(@status_url))
      result = doc.search("table")[4].search("tr")[1].search("td")

      @submission.original_id ||= result[0].inner_html

      status = result[3].at("font").inner_html
      @submission.status = ApplicationController.helpers.status_list[status =~ /Running/ ? "Running" : status]
      if status == "Accepted"
        @submission.memory = result[4].inner_html[/\d+/]
        @submission.time = result[5].inner_html[/\d+/]
      elsif status == "Compile Error"
        doc = Hpricot(open("#{BaseURL}/showcompileinfo?solution_id=#{@submission.original_id}"))
        @submission.error = doc.at("pre").inner_html
      end

      @submission.save
    end
  end
end
