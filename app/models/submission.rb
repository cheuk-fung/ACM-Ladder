class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  attr_accessible :code, :language
  validates_presence_of :user_id, :problem_id, :code, :language

  def submit
    case self.problem.source
    when "POJ"
      submit_poj
    when "NKOJ"
      submit_nkoj
    end
  end
  handle_asynchronously :submit, :queue => "submit"

  private

  def submit_poj
    # Submit to POJ and keep checking status until judgement finishes.
    # Current local submission is bound to the last remote submission,
    # so this method can't run in parallel.

    require "net/http"

    base_url = "http://poj.org"
    login_url = "#{base_url}/login"
    submit_url = "#{base_url}/submit"
    status_url = "#{base_url}/status?problem_id=#{self.problem.original_id}&user_id=#{ENV['POJ_HANDLE']}"

    languages = { "C++" => 0, "C" => 1, "Java" => 2, "Pascal" => 3 }
    language = languages[ApplicationController.helpers.language_list.invert[self.language]]

    # TODO: handles errors
    uri = URI(base_url)
    Net::HTTP.start(uri.host, uri.port) do |http|
      uri = URI(login_url)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({ 'user_id1' => ENV['POJ_HANDLE'], 'password1' => ENV['POJ_PASSWORD']})
      response = http.request(request)
      cookies = response.response['set-cookie']

      uri = URI(submit_url)
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Cookie'] = cookies
      request.set_form_data({ 'problem_id' => self.problem.original_id,
                              'language' => language,
                              'source' => self.code })
      response = http.request(request)
    end

    require "open-uri"

    while self.status <= 2 # waiting, compiling or running
      doc = Hpricot(open(status_url))
      result = doc.search("table")[4].search("tr")[1].search("td")
      self.original_id ||= result[0].inner_html
      status = result[3].at("font").inner_html
      self.status = ApplicationController.helpers.status_list[status =~ /Running/ ? "Running" : status]
      if status == "Accepted"
        self.memory = result[4].inner_html[/\d+/]
        self.time = result[5].inner_html[/\d+/]
      elsif status == "Compile Error"
        doc = Hpricot(open("#{base_url}/showcompileinfo?solution_id=#{self.original_id}"))
        self.error = doc.at("pre").inner_html
      end
      self.save
    end
  end
end
