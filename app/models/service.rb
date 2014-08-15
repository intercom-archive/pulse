class Service < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true

  has_many :metrics

  def latest_three_metrics
    metrics.order(updated_at: :desc).limit(3)
  end
end
