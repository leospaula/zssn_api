require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe "resource fields" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:quantity) }
  end

  describe "resources relationships" do 
    it { is_expected.to belong_to(:survivor) }
  end
end
