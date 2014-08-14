class GraphiteMetric
  GRAPHITE_USER = ENV['GRAPHITE_USERNAME']
  GRAPHITE_PASSWORD = ENV['GRAPHITE_PASSWORD']
  GRAPHITE_BASE = ENV['GRAPHITE_URL']

  def initialize(name, identifier)
    @name = name
    @identifier = identifier
    @options = default_options
  end

  def datapoints
    auth = { username: GRAPHITE_USER, password: GRAPHITE_PASSWORD }
    begin
      response = HTTParty.get(url, :basic_auth => auth, :timeout => 5)
    rescue Exception => e
      Rails.logger.info("Failed retrieving graphite metrics for url: #{url}")
      Rails.logger.info("#{e.inspect}")
      return []
    end
    response.first.datapoints
  end

  private
  def default_options
    {
      :format => "json",
      :from => "-1hours",
      :title => @name,
      :target => @identifier,
    }
  end

  def url
    "#{GRAPHITE_BASE}/render/?#{@options.to_query}"
  end
end
