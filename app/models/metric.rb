class Metric < ActiveRecord::Base
  DATAPOINT_SOURCE_VALUES = %w(graphite).freeze

  validates :title, presence: true
  validates :datapoint_source, inclusion: { in: DATAPOINT_SOURCE_VALUES }
  validates :datapoint_name, presence: true

  belongs_to :service
end
