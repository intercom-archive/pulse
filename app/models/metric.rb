class Metric < ActiveRecord::Base
  DATAPOINT_SOURCE_VALUES = %w(graphite cloudwatch).freeze
  CLOUDWATCH_NAMESPACES = %w(AWS/ELB AWS/RDS AWS/SNS AWS/SQS).freeze

  validates :title, presence: true
  validates :datapoint_source, inclusion: { in: DATAPOINT_SOURCE_VALUES }
  validates :datapoint_name, presence: true

  validates :cloudwatch_namespace, inclusion: { in: CLOUDWATCH_NAMESPACES }, if: :cloudwatch_metric?
  validates :cloudwatch_identifier, presence: true, if: :cloudwatch_metric?

  def cloudwatch_metric?
    datapoint_source == 'cloudwatch'
  end

  def graphite_data
    @graphite_data ||= GraphiteMetric.new(title, datapoint_name).datapoints
  end

  belongs_to :service
end
