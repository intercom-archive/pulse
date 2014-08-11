require 'rails_helper'

RSpec.describe "metrics/show", :type => :view do
  before(:each) do
    @metric = assign(:metric, Metric.create!(
      :title => "Title",
      :datapoint_source => "Datapoint Source",
      :datapoint_name => "Datapoint Name",
      :summary => "MyText",
      :mitigation_steps => "Mitigation Steps",
      :contact => "Contact"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Datapoint Source/)
    expect(rendered).to match(/Datapoint Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Mitigation Steps/)
    expect(rendered).to match(/Contact/)
  end
end
