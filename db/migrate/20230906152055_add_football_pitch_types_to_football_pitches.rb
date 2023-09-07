class AddFootballPitchTypesToFootballPitches < ActiveRecord::Migration[7.0]
  def change
    add_column :football_pitches, :football_pitch_types, :integer
  end
end
