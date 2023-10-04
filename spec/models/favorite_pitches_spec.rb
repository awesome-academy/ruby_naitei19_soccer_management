require "rails_helper"

RSpec.describe FavoritePitch, type: :model do
  context "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:football_pitch) }
  end
end
