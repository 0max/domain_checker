require 'ruby-progressbar'

require './lib/report'
require './lib/options_processor'
require './lib/domain'

def main options, invalid_domains = [], http_failed_domains = [], http_valid_domains = [], http_redirected_domains = [], https_failed_domains = [], https_valid_domains = []
  progressbar = ProgressBar.create(title: "Tested Domains", starting_at: 0, total: File.open(options[:file]).count, remainder_mark: '='.red, progress_mark: '='.green)

  File.open(options[:file]).each_with_index do |line, index|

    progressbar.increment
    cur_domain = Domain.new(url: line)

    # Is the string a domain ?
    if cur_domain.valid?

      http_res = cur_domain.http_response(options[:timeout])

      if http_res && [301,302,303,200].include?(http_res.status.to_i)

        # HTTP Redirection test
        if [301,302,303].include?(http_res.status.to_i)
          http_redirected_domains << [cur_domain.http_url, http_res.headers['location']]
          cur_domain.url = http_res.headers['location'].gsub(/(https?):\/\//,'').gsub(/(www\.)/,'')
        else
          http_valid_domains << cur_domain.http_url
        end

        if cur_domain.https_response(options[:timeout])
          https_valid_domains << cur_domain.https_url
        else
          https_failed_domains << cur_domain.https_url
        end

      else
        http_failed_domains << cur_domain.http_url
      end

    else
      invalid_domains << cur_domain.url
    end

  end

  report = Report.new(
    {
      invalid_domains: invalid_domains,
      http_failed_domains: http_failed_domains,
      http_redirected_domains: http_redirected_domains,
      http_valid_domains: http_valid_domains,
      https_failed_domains: https_failed_domains,
      https_valid_domains: https_valid_domains
    }
  )

  puts report.print
end

options = OptionsProccessor.new.options
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE unless options[:check_ssl_certificate]

main(options);
