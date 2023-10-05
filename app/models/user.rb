class User < ApplicationRecord
  before_save :downcase_email!
  before_create :create_activation_digest
  attr_accessor :remember_token, :activation_token, :reset_token

  # callback
  before_save :downcase_email!

  # validate
  validates :phone, presence: true
  validates :name, presence: true, length: {maximum: Settings.users.max_name}
  validates :password, presence: true,
                       length: {minimum: Settings.users.min_password},
                       format: {with: Settings.users.valid_password_regex},
                       allow_nil: true
  validates :email, presence: true,
                    length: {maximum: Settings.users.max_email},
                    format: {with: Settings.users.valid_email_regex},
                    uniqueness: true
  has_secure_password

  scope :non_admin, ->{where(is_admin: nil)}
  scope :by_user, ->(user){where("name LIKE ?", "%#{user}%")}
  scope :by_email, ->(email){where("email LIKE ?", "%#{email}%")}
  scope :by_phone, ->(phone){where("phone LIKE ?", "%#{phone}%")}
  # association
  has_many :favorite_pitches, dependent: :destroy
  has_many :football_pitches, through: :favorite_pitches,
                              source: :football_pitch
  has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy

  # class methods
  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end

    # Delete invalid user accounts
    def delete_invalid_user user
      user.delete
    end

    def admin
      User.where(is_admin: true)
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_column(:remember_digest, nil)
  end

  def session_token
    remember_digest || remember
  end

  # Activates an account.
  def activate
    update_columns(is_activated: true, activation_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_approve_booking_email
    UserMailer.approve_booking(self).deliver_now
  end

  def send_reject_booking_email
    UserMailer.reject_booking(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_digest_at: Time.zone.now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_digest_at < 2.hours.ago
  end

  def favorite? football_pitch
    football_pitches.exists?(id: football_pitch.id)
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  private
  def downcase_email!
    email.downcase!
  end
end
