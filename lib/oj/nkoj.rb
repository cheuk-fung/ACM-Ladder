require 'net/http'
require 'open-uri'

# TODO: handles errors
module NKOJ
  BaseURL = "http://acm.nankai.edu.cn"
  Handle = ENV['NKOJ_HANDLE']
  Password = ENV['NKOJ_PASSWORD']

  lid = OJ::LanguageID
  LanguageDict = { "C (gcc)" => lid[:c], "C++ (g++)" => lid[:cpp], "Java (jdk6)" => lid[:java], "Pascal (fpc)" => lid[:pascal] }
  LanguageSubmitID = { lid[:c] => 0, lid[:cpp] => 1, lid[:java] => 3, lid[:pascal] => 2 }

  class << self
    def submit(submission)
      uri = URI(BaseURL)
      language = LanguageSubmitID[submission.language]
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
                                'prob_id' => submission.problem.original_id,
                                'language' => language,
                                'source' => submission.code })
        response = http.request(request)

        # The body of response contains the final status of this submission.
        doc = Hpricot(response.body)
        result = doc.search("font")

        submission.original_id = result[0].inner_html[/\d+/]

        if result[1].at("a")
          status = "Compile Error"
        else
          status = result[1].at("span").inner_html
        end
        status = OJ::StatusNameToSym[status]
        submission.status = OJ::StatusSymToID[status]
        if status == :ac
          submission.memory = result[2].inner_html[/\d+ KB/][/\d+/]
          submission.time = result[2].inner_html[/\d+ ms/][/\d+/]
        elsif status == :ce
          uri = URI("#{BaseURL}/user_cmpinfo.php?id=#{submission.original_id}")
          request = Net::HTTP::Get.new(uri.request_uri)
          request['Cookie'] = cookies
          response = http.request(request)
          doc = Hpricot(response.body)
          submission.error = doc.at("pre").inner_html
        end

        submission.save
      end
    end

    def fetch(problem)
      doc = Hpricot(open(url = "#{BaseURL}/p#{problem.original_id}.html").read.encode('UTF-8', 'GBK'))

      result = doc.at("#p_title_c")
      return if result.nil?
      problem.title = result.inner_html.split(': ')[1].strip

      for item in doc/"img"
        item['src'] = "#{BaseURL}/" + item['src']
      end

      problem.time_limit = doc.at("#fm_tl").inner_html[/\d+/]
      problem.memory_limit = doc.at("#fm_ml").inner_html[/\d+/]

      problem.description = doc.at("#fm_d").inner_html
      problem.input = doc.at("#fm_i").inner_html
      problem.output = doc.at("#fm_o").inner_html
      problem.hint = doc.at("#fm_h").inner_html if doc.search("h2").inner_html.include?("Hint")

      problem.sample_input = doc.at("#fm_si").inner_html
      problem.sample_output = doc.at("#fm_so").inner_html
    end
  end
end
