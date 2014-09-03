class GraphiteMetric
  GRAPHITE_USER = ENV['GRAPHITE_USERNAME']
  GRAPHITE_PASSWORD = ENV['GRAPHITE_PASSWORD']
  GRAPHITE_BASE = ENV['GRAPHITE_URL']

  attr_writer :start_time, :end_time

  def initialize(name, identifier)
    @name = name
    @identifier = identifier
    @options = default_options
  end

  def datapoints
    auth = { username: GraphiteMetric::GRAPHITE_USER, password: GraphiteMetric::GRAPHITE_PASSWORD }
    begin
      response = HTTParty.get(url, :basic_auth => auth, :timeout => 5)
    rescue Exception => e
      Rails.logger.info("Failed retrieving graphite metrics for url: #{url}")
      Rails.logger.info("#{e.inspect}")
      return []
    end
    response.first['datapoints']
  end

  def start_time=(time)
    @options[:from] = time.to_i
  end

  def end_time=(time)
    @options[:until] = time.to_i
  end

  private
    def default_options
      {
        :format => "json",
        :from => "-10minutes",
        :title => @name,
        :target => @identifier,
        :until => nil
      }
    end

    def url
      "#{GRAPHITE_BASE}/render/?#{@options.to_query}"
    end
end
