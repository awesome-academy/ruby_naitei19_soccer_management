# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) } # Sử dụng FactoryGirl hoặc FactoryBot để tạo đối tượng User

  describe 'validations' do
    required_attributes = %i(phone name email)
    it { should validate_length_of(:name).is_at_most(Settings.users.max_name) }
    it { should validate_length_of(:email).is_at_most(Settings.users.max_email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should have_secure_password }
    it { should_not allow_value('invalid').for(:password) }
    required_attributes.each do |attribute|
      it { should validate_presence_of(attribute) }
    end
  end

  describe 'associations' do
    it { should have_many(:favorite_pitches).dependent(:destroy) }
    it { should have_many(:football_pitches).through(:favorite_pitches).source(:football_pitch) }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:bookings).dependent(:destroy) }
  end

  describe 'methods' do
    it 'creates activation digest' do
      user = build(:user)
      user.create_activation_digest
      expect(user.activation_digest).not_to be_nil
    end

    it 'remembers user' do
      user = build(:user)
      user.remember
      expect(user.remember_digest).not_to be_nil
    end
  end
end
