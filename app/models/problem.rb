class Problem < ActiveRecord::Base
  attr_accessible :description, :hint, :input, :level, :memory_limit, :original_id, :output, :sample_input, :sample_output, :source, :time_limit, :title
  validates_presence_of :description, :input, :level, :memory_limit, :original_id, :output, :sample_input, :sample_output, :source, :time_limit, :title

  def fetch_remote
    case source
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
    title = doc.search("div.ptt").inner_html
  end
end
