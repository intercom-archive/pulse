class Metric < ActiveRecord::Base
  DATAPOINT_SOURCE_VALUES = %w(graphite cloudwatch)
  CLOUDWATCH_NAMESPACES = %w(AWS/EC2 AWS/RDS AWS/SNS AWS/SQS)

  belongs_to :service

  validates :title, presence: true
  validates :datapoint_source, inclusion: { in: DATAPOINT_SOURCE_VALUES }
  validates :datapoint_name, presence: true

  validates :cloudwatch_namespace, inclusion: { in: CLOUDWATCH_NAMESPACES }, if: :cloudwatch_metric?
  validates :cloudwatch_identifier, presence: true, if: :cloudwatch_metric?

  def cloudwatch_metric?
    datapoint_source == 'cloudwatch'
  end

  def graphite_metric?
    datapoint_source == 'graphite'
  end

  def datapoints
    return @datapoints unless @datapoints.nil?
    if cloudwatch_metric?
      @datapoints = CloudwatchMetric.new(cloudwatch_namespace, datapoint_name, cloudwatch_identifier).datapoints
    else
      @datapoints = GraphiteMetric.new(title, datapoint_name).datapoints
    end
  end

  def sidebar_data
    attrs = [:summary, :mitigation_steps, :contact]
    attrs.concat([:cloudwatch_namespace, :cloudwatch_identifier]) if cloudwatch_metric?
    attrs.reduce({}) do |hsh, attr|
      hsh[attr] = send(attr)
      hsh
    end
  end
end
