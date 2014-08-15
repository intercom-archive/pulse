class Service < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true

  has_many :metrics, dependent: :destroy

  def last_n_metrics(n)
    metrics.order(updated_at: :desc).limit(n)
  end
end
