class Problem < ActiveRecord::Base
  has_many :submissions
  attr_accessible :level, :original_id, :source
  validates_presence_of :description, :input, :level, :memory_limit, :original_id, :output, :sample_input, :sample_output, :source, :time_limit, :title

  def fetch_remote
    case self.source
    when "POJ"
      fetch_poj
    when "NKOJ"
      fetch_nkoj
    end
  end

  private

  def fetch_poj
    return if self.original_id.nil?

    require "open-uri"

    url = "http://poj.org/problem?id=#{self.original_id}"
    doc = Hpricot(open(url))

    result = doc.at("div.ptt")
    return if result.nil?
    self.title = result.inner_html

    result = doc/"div.plm td"
    self.time_limit = result[0].inner_html[/\d+/]
    self.memory_limit = result[2].inner_html[/\d+/]

    result = doc/"div.ptx"
    self.description = result[0].inner_html
    self.input = result[1].inner_html
    self.output = result[2].inner_html
    self.hint = result[3].inner_html if doc.search("p.pst").inner_html.include?("Hint")

    result = doc/"pre.sio"
    self.sample_input = result[0].inner_html
    self.sample_output = result[1].inner_html
  end
end
