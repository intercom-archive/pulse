require 'rails_helper'

RSpec.describe "metrics/edit", :type => :view do
  before(:each) do
    @metric = assign(:metric, Metric.create!(
      :title => "MyString",
      :datapoint_source => "",
      :datapoint_name => "MyString",
      :summary => "MyText",
      :mitigation_steps => "MyString",
      :contact => "MyString"
    ))
  end

  it "renders the edit metric form" do
    render

    assert_select "form[action=?][method=?]", metric_path(@metric), "post" do

      assert_select "input#metric_title[name=?]", "metric[title]"

      assert_select "input#metric_datapoint_source[name=?]", "metric[datapoint_source]"

      assert_select "input#metric_datapoint_name[name=?]", "metric[datapoint_name]"

      assert_select "textarea#metric_summary[name=?]", "metric[summary]"

      assert_select "input#metric_mitigation_steps[name=?]", "metric[mitigation_steps]"

      assert_select "input#metric_contact[name=?]", "metric[contact]"
    end
  end
end
