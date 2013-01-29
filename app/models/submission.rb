class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem
  attr_accessible :code, :language
  validates_presence_of :problem_id, :code, :language # :user_id

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
    status_url = "#{base_url}/status?problem_id=#{self.problem_id}&user_id=#{ENV['POJ_HANDLE']}"

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
  end
end
