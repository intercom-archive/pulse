class CloudwatchMetric
  attr_writer :start_time, :end_time

  CLOUDWATCH_IDENTIFIER_MAP = {
      'AWS/EC2' => 'AutoScalingGroupName',
      'AWS/ELB' => 'LoadBalancerName',
      'AWS/RDS' => 'DBInstanceIdentifier',
      'AWS/SNS' => 'Application',
      'AWS/SQS' => 'QueueName'
  }

  def initialize(namespace, metric, identifier)
    @namespace = namespace
    @metric = metric
    @identifier = identifier
    @cloudwatch_metric = AWS::CloudWatch::Metric.new(namespace, metric, :dimensions => [dimensions])
    @start_time = Time.now - 600
    @end_time = Time.now
  end

  def datapoints
    statistics = @cloudwatch_metric.statistics(statistics_options).sort_by { |e| e[:timestamp] }
    statistics = statistics.map { |datapoint| [datapoint[:average], datapoint[:timestamp].to_i] }
  rescue Exception => e
    Rails.logger.info("Failed retrieving cloudwatch metrics for: #{@namespace} #{@metric} #{@identifier}")
    Rails.logger.info("#{e.inspect}")
    return []
  end

  def start_time=(time)
    @start_time = time
  end

  def end_time=(time)
    @end_time = time
  end

  private
    def dimensions
      { name: CLOUDWATCH_IDENTIFIER_MAP[@namespace], value: @identifier }
    end

    def statistics_options
      { statistics: ["Average"], start_time: @start_time, end_time: @end_time }
    end
end
