require 'rails_helper'
require 'uri'

RSpec.describe GraphiteMetric, :type => :library do

  let(:metric_title) { "User-friendly metric title" }
  let(:metric_identifier) { "my.metric.name.in.graphite" }
  let(:subject) { GraphiteMetric }
  let(:graphite_metric) { subject.new(metric_title, metric_identifier) }
  let(:example_datapoints) { [[0, 10], [1, 40]] }
  let(:example_response) { OpenStruct.new('datapoints' => example_datapoints) }

  describe "#initialize" do
    describe "with valid params" do
      it "creates a new GraphiteMetric" do
        graphite_metric = subject.new(metric_title, metric_identifier)
        expect(graphite_metric).to be_a(GraphiteMetric)
      end
    end

    describe "with invalid params" do
      it "throws an exception when no metric identifier or title are provided" do
        expect{ subject.new }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#datapoints" do
    it "gets the URL to obtain the datapoints" do
      expect(HTTParty).to receive(:get).and_return([example_response])
      expect(graphite_metric.datapoints).to eq(example_datapoints)
    end

    it "rescues and returns an empty datapoint array on GET issues" do
      expect(HTTParty).to receive(:get).and_raise(TimeoutError)
      expect(graphite_metric.datapoints).to eq([])
    end
  end

  describe "#start_time=" do
    it "sets the start time in unix form for fetching datapoints" do
      now = Time.now
      graphite_metric.start_time = now
      opts = graphite_metric.instance_variable_get(:@options)
      expect(opts[:from]).to eq(now.to_i)
    end
  end

  describe "#end_time=" do
    it "sets the end time in unix form for fetching datapoints" do
      now = Time.now
      graphite_metric.end_time = now
      opts = graphite_metric.instance_variable_get(:@options)
      expect(opts[:until]).to eq(now.to_i)
    end
  end
end
