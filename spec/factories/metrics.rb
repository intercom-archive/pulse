# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence (:title) { |n| "Test Metric #{n}" }
  sequence (:datapoint_source) { %w(graphite cloudwatch).sample }
  sequence (:datapoint_name) { |n| "metric#{n}" }

  factory :metric do
    title
    datapoint_source
    datapoint_name
    summary "Metric Summary"
    mitigation_steps "Migitation Steps"
    contact "It's only a test"
    cloudwatch_namespace "AWS/EC2"
    cloudwatch_identifier "some-id"
    alarm_warning 5
    alarm_error 20
  end
end
