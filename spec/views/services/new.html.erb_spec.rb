require 'rails_helper'

RSpec.describe "services/new", :type => :view do
  before(:each) do
    assign(:service, Service.new(
      :title => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new service form" do
    render

    assert_select "form[action=?][method=?]", services_path, "post" do

      assert_select "input#service_title[name=?]", "service[title]"

      assert_select "textarea#service_description[name=?]", "service[description]"
    end
  end
end
