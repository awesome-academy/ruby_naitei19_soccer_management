require "rails_helper"

RSpec.describe FootballPitch, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(Settings.users.max_name) }
    it { should validate_presence_of(:location) }
    it { should validate_length_of(:location).is_at_most(Settings.users.max_text) }
    it { should validate_presence_of(:length) }
    it { should validate_numericality_of(:length).is_greater_than(Settings.pitches.min_length) }
    it { should validate_presence_of(:width) }
    it { should validate_numericality_of(:width).is_greater_than(Settings.pitches.min_length) }
    it { should validate_presence_of(:capacity) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(Settings.pitches.min_length) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:football_pitch_types) }
  end

  describe "associations" do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:favorite_pitches).dependent(:destroy) }
    it { should have_many(:users).through(:favorite_pitches) }
    it { should have_many(:favorited_by_users).through(:favorite_pitches).source(:user) }
    it { should have_many(:bookings).dependent(:destroy) }
    it { should have_many_attached(:images) }
  end

  describe "scopes" do
    it "orders by newest" do
      pitch1 = create(:football_pitch, created_at: 1.day.ago)
      pitch2 = create(:football_pitch, created_at: 2.days.ago)

      ordered_ids = FootballPitch.newest.pluck(:id)

      expect(pitch1.id).to eq(ordered_ids.first)
      expect(pitch2.id).to eq(ordered_ids.second)
    end

    it "searches by name when name is present" do
      pitch = create(:football_pitch, name: "Football Pitch A")
      expect(FootballPitch.search_by_name "A").to include pitch
    end

    it "searches by location when location is present" do
      pitch = create(:football_pitch, location: "Location A")
      expect(FootballPitch.search_by_location "A").to include pitch
    end

    it "searches by capacity when capacity is present" do
      pitch = create(:football_pitch, capacity: "10")
      expect(FootballPitch.search_by_capacity "10").to include pitch
    end

    it "searches by price range when min_price and max_price are present" do
      pitch = create(:football_pitch, price: 50)
      expect(FootballPitch.search_by_price(0, 100)).to include pitch
    end
  end

  describe "class methods" do
    it "checks if a football pitch is valid" do
      pitch = create(:football_pitch)
      booking = create(:booking, football_pitch: pitch, booking_status: :approve)
      expect(FootballPitch.is_valid_football_pitch? pitch).to be true
    end

    it "checks ransackable attributes" do
      expect(FootballPitch.ransackable_attributes).to include(
        "average_rating", "capacity", "created_at", "description",
        "football_pitch_types", "id", "length", "location", "name",
        "price", "updated_at", "width", "min_price", "max_price"
      )
    end

    it "checks ransackable associations" do
      expect(FootballPitch.ransackable_associations).to include(
        "bookings", "favorite_pitches", "favorited_by_users", "images_attachments",
        "images_blobs", "reviews", "users"
      )
    end
  end
end
