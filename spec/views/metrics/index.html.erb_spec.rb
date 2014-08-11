require 'rails_helper'

RSpec.describe "metrics/index", :type => :view do
  before(:each) do
    assign(:metrics, [
      Metric.create!(
        :title => "Title",
        :datapoint_source => "Datapoint Source",
        :datapoint_name => "Datapoint Name",
        :summary => "MyText",
        :mitigation_steps => "Mitigation Steps",
        :contact => "Contact"
      ),
      Metric.create!(
        :title => "Title",
        :datapoint_source => "Datapoint Source",
        :datapoint_name => "Datapoint Name",
        :summary => "MyText",
        :mitigation_steps => "Mitigation Steps",
        :contact => "Contact"
      )
    ])
  end

  it "renders a list of metrics" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Datapoint Source".to_s, :count => 2
    assert_select "tr>td", :text => "Datapoint Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Mitigation Steps".to_s, :count => 2
    assert_select "tr>td", :text => "Contact".to_s, :count => 2
  end
end
