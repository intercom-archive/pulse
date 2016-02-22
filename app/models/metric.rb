class Metric < ActiveRecord::Base
  DATAPOINT_SOURCE_VALUES = %w(graphite cloudwatch)
  CLOUDWATCH_NAMESPACES = %w(AWS/EC2 AWS/RDS AWS/SNS AWS/SQS)

  belongs_to :service

  validates :title, presence: true
  validates :datapoint_source, inclusion: { in: DATAPOINT_SOURCE_VALUES }
  validates :datapoint_name, presence: true
  validates :alarm_warning, presence: true
  validates :alarm_error, presence: true

  validates :cloudwatch_namespace, inclusion: { in: CLOUDWATCH_NAMESPACES }, if: :cloudwatch_metric?
  validates :cloudwatch_identifier, presence: true, if: :cloudwatch_metric?

  def cloudwatch_metric?
    datapoint_source == 'cloudwatch'
  end

  def graphite_metric?
    datapoint_source == 'graphite'
  end

  def datapoints(start_time = nil, end_time = nil)
    return @datapoints unless @datapoints.nil?
    if cloudwatch_metric?
      datapoint_lib = CloudwatchMetric.new(cloudwatch_namespace, datapoint_name, cloudwatch_identifier)
    else
      datapoint_lib = GraphiteMetric.new(title, datapoint_name)
    end
    datapoint_lib.start_time = start_time if start_time
    datapoint_lib.end_time = end_time if end_time
    @datapoints = datapoint_lib.datapoints
  end

  def alarm_state
    return 'error' if alarm_error?
    return 'warning' if alarm_warning?
    'normal'
  end

  def sidebar_data
    attrs = [:summary, :alarm_warning, :alarm_error, :negative_alarming?, :mitigation_steps, :contact]
    attrs.concat([:cloudwatch_namespace, :cloudwatch_identifier]) if cloudwatch_metric?
    attrs.reduce({}) do |hsh, attr|
      hsh[attr] = send(attr)
      hsh
    end
  end

  private
    def latest_datapoint
      return datapoints.map { |point| point unless point.first.nil? }.compact.last.first if graphite_metric?
      datapoints.last.first
    end

    def alarm_error?
      return latest_datapoint < alarm_error if negative_alarming?
      latest_datapoint > alarm_error
    end

    def alarm_warning?
      return false if alarm_error?
      return latest_datapoint < alarm_warning if negative_alarming?
      latest_datapoint > alarm_warning
    end
end
