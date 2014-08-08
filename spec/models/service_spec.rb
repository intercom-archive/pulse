require 'rails_helper'

RSpec.describe Service, :type => :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end
