require 'colorize'

class Report
  attr_accessor :invalid_domains, :http_failed_domains, :http_redirected_domains, :http_valid_domains, :https_failed_domains, :https_valid_domains

  def initialize(attributes = {}, options = {})
    @invalid_domains  = attributes[:invalid_domains]
    @http_failed_domains = attributes[:http_failed_domains]
    @http_redirected_domains = attributes[:http_redirected_domains]
    @http_valid_domains = attributes[:http_valid_domains]
    @https_failed_domains = attributes[:https_failed_domains]
    @https_valid_domains = attributes[:https_valid_domains]
  end

  def print_domain_collection collection, title, color = :white
    op = "————————————————————\n"

    op += "#{title} (#{collection.count})\n".send(color.to_sym)
    collection.each do |domain|
      domain_string = domain.is_a?(Array) ? domain.join(' => ') : domain.to_s
      op += "#{domain_string}\n".send(color.to_sym)
    end

    return op
  end

  def print_report_conclusion
    op = "————————————————————\n"
    op += "Report\n"
    op += "————————————————————\n"
    op += "Invalid Domains : #{self.invalid_domains.count}\n".red
    op += "HTTP GET Failure Domains : #{self.http_failed_domains.count}\n".red
    op += "Valid HTTP Domains : #{self.http_redirected_domains.count + self.http_valid_domains.count}\n".green
    op += "\tRedirected HTTP Domains : #{self.http_redirected_domains.count}\n".yellow
    op += "\tGET 200 HTTP Domains : #{self.http_valid_domains.count}\n".light_green
    op += "HTTPS GET failure Domains : #{self.https_failed_domains.count}\n".red
    op += "Valid HTTPS Domains : #{self.https_valid_domains.count}\n".green
    op += "————————————————————\n"
  end

  def print
    op = print_domain_collection(self.invalid_domains, 'Invalid Domains', :red)
    op += print_domain_collection(self.http_failed_domains, 'HTTP GET Failure Domains', :red)
    op += print_domain_collection(self.http_redirected_domains, 'HTTP GET Redirected Domains', :yellow)
    op += print_domain_collection(self.http_valid_domains, 'Valid HTTP Domains', :light_green)
    op += print_domain_collection(self.https_failed_domains, 'HTTPS GET failure Domains', :magenta)
    op += print_domain_collection(self.https_valid_domains, 'Valid HTTPS Domains', :green)
    op+= print_report_conclusion

    return op
  end

end
