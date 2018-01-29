require 'optparse'

class OptionsProccessor
  attr_accessor :options

  def initialize()
    @options = {}

    OptionParser.new do |parser|
      parser.on("-f", "--file SITE_FILE", "The file containing the site list.") do |v|
        @options[:file] = v
      end

      parser.on("-s", "--ssl-certificates-checking", "Add SSL certificates checking.") do |v|
        @options[:check_ssl_certificate] = true
      end

      parser.on("-t", "--timeout", "Define timeout for GET requests tests (in seconds).") do |v|
        @options[:timeout] = v
      end
    end.parse!

    raise 'You have to subit a file. See --help.' unless @options[:file]

    return @options
  end
end
