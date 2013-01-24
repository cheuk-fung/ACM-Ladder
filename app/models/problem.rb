class Problem < ActiveRecord::Base
  attr_accessible :level, :original_id, :source
  validates_presence_of :description, :input, :level, :memory_limit, :original_id, :output, :sample_input, :sample_output, :source, :time_limit, :title

  def fetch_remote!
    case self.source
    when "POJ"
      fetch_poj
    when "NKOJ"
      fetch_nkoj
    end
  end

  private
  def fetch_poj
    require "open-uri"

    url = "http://poj.org/problem?id=#{original_id}"
    doc = Hpricot(open(url))
    self.title = doc.search("div.ptt").inner_html
    if self.title == ""
      self.title = nil
      return
    end
    self.time_limit = doc.search("div.plm td")[0].inner_html[/\d+/]
    self.memory_limit = doc.search("div.plm td")[2].inner_html[/\d+/]
    self.description = doc.search("div.ptx")[0].inner_html
    self.input = doc.search("div.ptx")[1].inner_html
    self.output = doc.search("div.ptx")[2].inner_html
    self.sample_input = doc.search("pre.sio")[0].inner_html
    self.sample_output = doc.search("pre.sio")[1].inner_html
    self.hint = doc.search("div.ptx")[3].inner_html if doc.search("p.pst").inner_html.include?("Hint")
  end
end
