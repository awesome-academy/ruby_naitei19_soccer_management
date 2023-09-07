class FootballPitch < ApplicationRecord
  # enum
  enum football_pitch_types: {slot5: 0, slot7: 1, slot10: 2}

  # association
  has_many :reviews, dependent: :destroy
  has_many :favorite_pitches, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many_attached :images

  # nested attributes
  accepts_nested_attributes_for :bookings, allow_destroy: true
  accepts_nested_attributes_for :reviews, allow_destroy: true
  accepts_nested_attributes_for :favorite_pitches, allow_destroy: true

  # validate
  validates :name, presence: true, length: {maximum: Settings.users.max_name}
  validates :location, presence: true,
            length: {maximum: Settings.users.max_text}
  validates :length, presence: true, numericality: {greater_than: 0}
  validates :width, presence: true, numericality: {greater_than: 0}
  validates :capacity, presence: true,
            length: {maximum: Settings.users.max_text}
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :description, presence: true
  validates :football_pitch_types, presence: true,
            inclusion: {in: FootballPitch.football_pitch_types.keys}
  validates :images, presence: true
end
