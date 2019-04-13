require 'rails_helper'

RSpec.describe Survivor, type: :model do
  describe "survivor fields" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:last_location) }
  end

  describe "survivor relationships" do   
    it { is_expected.to have_many :resources }
  end
end
