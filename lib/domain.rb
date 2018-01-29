require 'net/https'
require 'faraday'
require 'timeout'

class Domain
  attr_accessor :url

  def initialize(attributes = {}, options = {})
    @url = attributes[:url].gsub(/(https?):\/\//,'').gsub(/(www\.)/,'').gsub(/[ \n]/,'')
  end

  def to_s
    return url.to_s
  end

  def valid?
    return false unless self.url.to_s != ''
    return self.url =~ /^[^\.\ ]*(\.[^\.\ ]*)*$/
  end

  def http_url
    return "http://#{self.url}"
  end

  def http_response timeout_sec = 5
    return begin
      Timeout::timeout(timeout_sec) {
        Faraday.get(self.http_url)
      }
    rescue
      false
    end
  end

  def https_response timeout_sec = 5
    begin
      Timeout::timeout(timeout_sec) {
        https_res = Faraday.get(self.https_url)

        if [301,302,303,200].include?(https_res.status.to_i)
          return https_res
        else
          return false
        end
      }
    rescue
      return false
    end
  end

  def https_url
    return "https://#{self.url}"
  end
end
