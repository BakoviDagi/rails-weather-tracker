class Location < ApplicationRecord
  belongs_to :user

  validates :address, presence: true, length: { minimum: 5 }
  validate :validate_address

  scope :ordered, -> { order(id: :desc) }

  scope :for_user, -> (current_user) { joins(:user).where(user: current_user) }

  def validate_address

    if WeatherApi.get_weather(address) == nil
      errors.add(:address, "Address not found by weather API!")
    end
  end
end
