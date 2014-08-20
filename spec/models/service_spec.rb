require 'rails_helper'

RSpec.describe Service, :type => :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#last_n_metrics" do
    let (:service) { FactoryGirl.create :service }
    let (:metrics) { [] }

    before (:each) {
      10.times do
        metric = FactoryGirl.create(:metric)
        metric.service = service
        metric.save
        metrics.push(metric)
      end
    }

    it "gets the last 3 metrics" do
      expect(service.last_n_metrics(3).count).to eq(3)
    end

    it "orders the metrics by updated at descending" do
      last_updated_metrics = metrics.from(5).sort_by { |a| a[:bar] }.reverse
      expect(service.last_n_metrics(5)).to eq(last_updated_metrics)
    end
  end
end
