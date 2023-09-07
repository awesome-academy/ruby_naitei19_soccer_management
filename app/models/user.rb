class User < ApplicationRecord
  # callback
  before_save :downcase_email!

  # validate
  validates :phone, presence: true
  validates :name, presence: true, length: {maximum: Settings.users.max_name}
  validates :password, presence: true,
                       length: {minimum: Settings.users.min_password},
                       format: {with: Settings.users.valid_password_regex}
  validates :email, presence: true,
                    length: {maximum: Settings.users.max_email},
                    format: {with: Settings.users.valid_email_regex},
                    uniqueness: true
  has_secure_password
  # association
  has_many :favorite_pitches, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy

  private
  def downcase_email!
    email.downcase!
  end
end
