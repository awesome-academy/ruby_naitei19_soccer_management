class FavoritePitch < ApplicationRecord
  # association
  belongs_to :user
  belongs_to :football_pitch
end
