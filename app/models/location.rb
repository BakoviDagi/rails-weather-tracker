class Location < ApplicationRecord
  validates :address, presence: true, length: { minimum: 5 }
  validate :validate_address

  scope :ordered, -> { order(id: :desc) }

  def validate_address

    if WeatherApi.get_weather(address) == nil
      errors.add(:address, "Address not found by weather API!")
    end
  end
end
