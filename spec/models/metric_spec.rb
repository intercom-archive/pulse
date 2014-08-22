require 'rails_helper'

RSpec.describe Metric, :type => :model do
  it { should validate_presence_of(:title) }
  it { should ensure_inclusion_of(:datapoint_source).in_array(Metric::DATAPOINT_SOURCE_VALUES) }
  it { should validate_presence_of(:datapoint_name) }
  it { should validate_presence_of(:alarm_warning) }
  it { should validate_presence_of(:alarm_error) }
  it { should belong_to(:service) }

  let(:graphite_metric) { Metric.new()}

  context "Graphite Metric" do
    let(:valid_attributes) {
      {
          title: "test_metric",
          datapoint_source: "graphite",
          datapoint_name: "my.graphite.metric",
          alarm_warning: 20,
          alarm_error: 40
      }
    }
    let(:metric) { Metric.new(valid_attributes) }

    describe "#graphite_metric?" do
      it "detects the metric as a graphite metric" do
        expect(metric.graphite_metric?).to eq(true)
      end
    end

    describe "cloudwatch_metric?" do
      it "does not detect the metric as a cloudwatch metric" do
        expect(metric.cloudwatch_metric?).to eq(false)
      end
    end

    describe "#datapoints" do
      it "calls the graphite lib for datapoints" do
        lib = instance_double(GraphiteMetric)
        expect(lib).to receive(:datapoints).and_return([])
        expect(GraphiteMetric).to receive(:new).and_return(lib)
        metric.datapoints
      end
    end

    describe "#sidebar_data" do
      it "includes the basic data in the sidebar" do
        expect(metric.sidebar_data.key?(:summary)).to eq(true)
        expect(metric.sidebar_data.key?(:contact)).to eq(true)
        expect(metric.sidebar_data.key?(:mitigation_steps)).to eq(true)
        expect(metric.sidebar_data.key?(:alarm_warning)).to eq(true)
        expect(metric.sidebar_data.key?(:alarm_error)).to eq(true)
        expect(metric.sidebar_data.key?(:negative_alarming?)).to eq(true)
      end
    end
  end

  context "Cloudwatch Metric" do
    let(:valid_attributes) {
      {
          title: "test_metric",
          datapoint_source: "cloudwatch",
          datapoint_name: "CPUUtilization",
          cloudwatch_namespace: "AWS/EC2",
          cloudwatch_identifier: "some-lb-name",
          alarm_warning: 20,
          alarm_error: 40
      }
    }
    let(:metric) { Metric.new(valid_attributes) }

    describe "#graphite_metric?" do
      it "detects the metric as a graphite metric" do
        expect(metric.graphite_metric?).to eq(false)
      end
    end

    describe "#cloudwatch_metric" do
      it "does not detect the metric as a cloudwatch metric" do
        expect(metric.cloudwatch_metric?).to eq(true)
      end
    end

    describe "#datapoints" do
      it "calls the cloudwatch lib for datapoints" do
        lib = instance_double(CloudwatchMetric)
        expect(lib).to receive(:datapoints).and_return([])
        expect(CloudwatchMetric).to receive(:new).and_return(lib)
        metric.datapoints
      end
    end

    describe "#sidebar" do
      it "includes the cloudwatch specific data in the sidebar" do
        expect(metric.sidebar_data.key?(:cloudwatch_namespace)).to eq(true)
        expect(metric.sidebar_data.key?(:cloudwatch_identifier)).to eq(true)
      end
    end
  end
end
