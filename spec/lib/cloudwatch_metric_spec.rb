require 'rails_helper'
AWS.stub!

RSpec.describe CloudwatchMetric, :type => :library do

  let(:namespace) { "AWS/RDS" }
  let(:metric) { "ReadIOPs" }
  let(:identifier) { "some-rds-name" }

  let(:subject) { CloudwatchMetric }
  let(:cw_metric) { subject.new(namespace, metric, identifier) }
  let(:aws_metric) { instance_double(AWS::CloudWatch::Metric) }
  let(:aws_metric_statistics) { AWS::CloudWatch::MetricStatistics.new(metric, identifier, aws_cw_datapoints) }

  let(:aws_cw_datapoints) { [
      { :timestamp => Time.parse("2014-08-20 18:05:00 UTC"), :unit => "Percent", :average => 38.268 },
      { :timestamp => Time.parse("2014-08-20 18:03:00 UTC"), :unit => "Percent", :average => 36.57714285714286 },
      { :timestamp => Time.parse("2014-08-20 17:58:00 UTC"), :unit => "Percent", :average => 28.797142857142855 },
      { :timestamp => Time.parse("2014-08-20 18:04:00 UTC"), :unit => "Percent", :average => 31.890000000000004 },
      { :timestamp => Time.parse("2014-08-20 18:00:00 UTC"), :unit => "Percent", :average => 47.35 },
      { :timestamp => Time.parse("2014-08-20 17:59:00 UTC"), :unit => "Percent", :average => 28.979999999999997 },
      { :timestamp => Time.parse("2014-08-20 17:56:00 UTC"), :unit => "Percent", :average => 30.145714285714288 },
      { :timestamp => Time.parse("2014-08-20 18:02:00 UTC"), :unit => "Percent", :average => 36.21714285714286 },
      { :timestamp => Time.parse("2014-08-20 18:01:00 UTC"), :unit => "Percent", :average => 40.104285714285716 },
      { :timestamp => Time.parse("2014-08-20 17:57:00 UTC"), :unit => "Percent", :average => 36.46857142857143 }
  ] }

  let(:expected_datapoints) { [
      [30.145714285714288, 1408557360],
      [36.46857142857143, 1408557420],
      [28.797142857142855, 1408557480],
      [28.979999999999997, 1408557540],
      [47.35, 1408557600],
      [40.104285714285716, 1408557660],
      [36.21714285714286, 1408557720],
      [36.57714285714286, 1408557780],
      [31.890000000000004, 1408557840],
      [38.268, 1408557900]
  ] }

  describe "#datapoints" do
    context "with stubbed responses" do
      before(:each) do
        expect(AWS::CloudWatch::Metric).to receive(:new).and_return(aws_metric)
        expect(aws_metric).to receive(:statistics).and_return(aws_metric_statistics)
      end

      it "returns the correct number of datapoints" do
        expect(cw_metric.datapoints.length).to eq(aws_cw_datapoints.length)
      end

      it "returns datapoints ordered by time ascending" do
        cw_metric.datapoints.each_cons(2) do |e|
          expect( e[1][1] > e[0][1] ).to eq(true)
        end
      end

      it "transposes the AWS format of statistics to the expected datapoint format" do
        test_metric = subject.new(namespace, metric, identifier)
        expect(test_metric.datapoints).to eq(expected_datapoints)
      end
    end

    context "with failed datapoint retrieval" do
      before(:each) {
        expect(AWS::CloudWatch::Metric).to receive(:new).and_return(aws_metric)
        expect(aws_metric).to receive(:statistics).and_raise(StandardError)
      }

      it "logs the error" do
        expect(Rails.logger).to receive(:info).twice
        cw_metric.datapoints
      end

      it "returns an empty array" do
        expect(cw_metric.datapoints).to eq([])
      end
    end
  end

  describe "#initialize" do
    describe "with valid params" do
      it "creates a new CloudwatchMetric" do
        cw_metric = subject.new(namespace, metric, identifier)
        expect(cw_metric).to be_a(CloudwatchMetric)
      end
    end

    describe "with invalid params" do
      it "throws an exception when no args are provided" do
        expect{ subject.new }.to raise_error(ArgumentError)
      end
    end
  end
end
