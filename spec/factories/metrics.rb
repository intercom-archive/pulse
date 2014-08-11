# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :metric do
    title "MyString"
    datapoint_source ""
    datapoint_name "MyString"
    summary "MyText"
    mitigation_steps "MyString"
    contact "MyString"
  end
end
