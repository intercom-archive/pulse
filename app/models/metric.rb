class Metric < ActiveRecord::Base
  DATAPOINT_SOURCE_VALUES = %w(graphite cloudwatch)
  CLOUDWATCH_NAMESPACES = %w(AWS/ELB AWS/RDS AWS/SNS AWS/SQS)

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

  def graphite_data
    @graphite_data ||= GraphiteMetric.new(title, datapoint_name).datapoints
  end

  def sidebar_data
    attrs = [:summary, :mitigation_steps, :contact]
    attrs.concat([:cloudwatch_namespace, :cloudwatch_namespace]) if cloudwatch_metric?
    attrs.reduce({}) do |hsh, attr|
      hsh[attr] = send(attr)
      hsh
    end
  end
end
