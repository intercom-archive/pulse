require 'rails_helper'

RSpec.describe Metric, :type => :model do
  it { should validate_presence_of(:title) }
  it { should ensure_inclusion_of(:datapoint_source).in_array(Metric::DATAPOINT_SOURCE_VALUES) }
  it { should validate_presence_of(:datapoint_name) }
end
