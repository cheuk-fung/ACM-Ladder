require 'net/http'
require 'open-uri'

# TODO: handles errors
class NKOJ
  BaseURL = "http://acm.nankai.edu.cn"
  Handle = ENV['NKOJ_HANDLE']
  Password = ENV['NKOJ_PASSWORD']
  Languages = { "C" => 0, "C++" => 1, "Pascal" => 2, "Java" => 3 }

  def initialize(s)
    @submission = s
    @status_url = "#{BaseURL}/solutions.php?pid=#{s.problem.original_id}&user=#{Handle}"
    @language = Languages[ApplicationController.helpers.language_list.invert[s.language]]
  end

  def submit
    uri = URI(BaseURL)
    Net::HTTP.start(uri.host, uri.port) do |http|
      uri = URI("#{BaseURL}/login.php")
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({ 'username' => Handle, 'password' => Password })
      response = http.request(request)
      cookies = response.response['set-cookie']
      sleep 1

      uri = URI("#{BaseURL}/submit.php")
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Cookie'] = cookies
      response = http.request(request)
      doc = Hpricot(response.body)
      password = doc.at("#password")['value']
      sleep 1

      uri = URI("#{BaseURL}/submit_process.php")
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Cookie'] = cookies
      request.set_form_data({ 'username' => Handle,
                              'password' => password,
                              'prob_id' => @submission.problem.original_id,
                              'language' => @language,
                              'source' => @submission.code })
      response = http.request(request)

      # The body of response contains the status of this submission.
      response.body
    end
  end
end
