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

      it "sets the start time if a start time was provided" do
        lib = instance_double(GraphiteMetric)
        time = Time.now
        expect(lib).to receive(:start_time=).with(time)
        expect(lib).to receive(:datapoints).and_return([])
        expect(GraphiteMetric).to receive(:new).and_return(lib)
        metric.datapoints(time)
      end

      it "sets the end time if an end time was provided" do
        lib = instance_double(GraphiteMetric)
        time = Time.now
        expect(lib).to receive(:start_time=)
        expect(lib).to receive(:end_time=).with(time)
        expect(lib).to receive(:datapoints).and_return([])
        expect(GraphiteMetric).to receive(:new).and_return(lib)
        metric.datapoints(time - 60, time)
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

    describe "#alarm_state" do
      before(:each) {
        lib = instance_double(GraphiteMetric)
        allow(lib).to receive(:datapoints).and_return([
          [30, 0],
          [432, 10],
          [2534, 20],
          [312, 30],
          [13, 40],
          [0, 50]
        ])
        allow(GraphiteMetric).to receive(:new).and_return(lib)
      }

      it "detects the metric in a normal state" do
        expect(metric.alarm_state).to eq("normal")
      end

      it "skips the last metric for Graphite (probably zero)" do
        metric.alarm_error = 10
        expect(metric.alarm_state).to_not eq("normal")
      end

      context "with regular alarming" do
        it "detects the metric in a warning state" do
          metric.alarm_warning = 10
          expect(metric.alarm_state).to eq("warning")
        end

        it "detects the metric in an error state" do
          metric.alarm_warning = 5
          metric.alarm_error = 10
          expect(metric.alarm_state).to eq("error")
        end
      end

      context "with negative alarming" do
        before(:each) {
          metric.negative_alarming = true
        }

        it "detects the metric in a warning state" do
          metric.alarm_warning = 20
          metric.alarm_error = 10
          expect(metric.alarm_state).to eq("warning")
        end

        it "detects the metric in an error state" do
          metric.alarm_warning = 20
          metric.alarm_error = 15
          expect(metric.alarm_state).to eq("error")
        end
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
          alarm_warning: 500,
          alarm_error: 600
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

      it "sets the start time if a start time was provided" do
        lib = instance_double(CloudwatchMetric)
        time = Time.now
        expect(lib).to receive(:start_time=).with(time)
        expect(lib).to receive(:datapoints).and_return([])
        expect(CloudwatchMetric).to receive(:new).and_return(lib)
        metric.datapoints(time)
      end

      it "sets the end time if an end time was provided" do
        lib = instance_double(CloudwatchMetric)
        time = Time.now
        expect(lib).to receive(:start_time=)
        expect(lib).to receive(:end_time=).with(time)
        expect(lib).to receive(:datapoints).and_return([])
        expect(CloudwatchMetric).to receive(:new).and_return(lib)
        metric.datapoints(time - 60, time)
      end
    end

    describe "#sidebar" do
      it "includes the cloudwatch specific data in the sidebar" do
        expect(metric.sidebar_data.key?(:cloudwatch_namespace)).to eq(true)
        expect(metric.sidebar_data.key?(:cloudwatch_identifier)).to eq(true)
      end
    end

    describe "#alarm_state" do
      before(:each) {
        lib = instance_double(CloudwatchMetric)
        allow(lib).to receive(:datapoints).and_return([
          [30, 0],
          [432, 10],
          [500, 20]
        ])
        allow(CloudwatchMetric).to receive(:new).and_return(lib)
      }

      it "detects the metric in a normal state" do
        expect(metric.alarm_state).to eq("normal")
      end

      it "does not skip the last metric for Cloudwatch" do
        metric.alarm_error = 450
        expect(metric.alarm_state).to eq("error")
      end
    end
  end
end
