require "application_system_test_case"

class LocationsTest < ApplicationSystemTestCase
  setup do
    @location = Location.ordered.first
    response = file_fixture("weather-api.json").read
    stub_request(:any, /api.weatherapi.com/)
      .to_return body: response, headers: {content_type: 'application/json'}
  end

  test "Creating a new Location" do
    visit locations_path
    assert_selector "h1", text: "Weather Tracker"

    click_on "Add Location"
    assert_selector "h1", text: "Weather Tracker"

    fill_in "Address", with: "54703"
    click_on "Add"

    assert_selector "h1", text: "Weather Tracker"
    assert_text "54703"
  end

  test "Cancelling a new location" do
    visit locations_path
    assert_selector "h1", text: "Weather Tracker"

    click_on "Add Location"

    fill_in "Address", with: "To Cancel"
    click_on "Cancel"

    assert_text "To Cancel", count: 0
    assert_selector "input", count: 0
  end

  test "Showing a Location" do
    visit locations_path
    click_link @location.address

    assert_text "Eau Claire, WI"
    assert_text "Saturday - Moderate or heavy snow showers"
    assert_text "Sunday - Moderate or heavy snow showers"
    assert_text "Monday - Light freezing rain"
  end

  test "Showing a Location Failed" do
    stub_request(:any, /api.weatherapi.com/)
      .to_return status: 500

    visit locations_path
    click_link @location.address

    assert_text "Error retrieving weather data! Please try again later"
  end

  test "Update a Location" do
    visit locations_path
    assert_selector "h1", text: "Weather Tracker"

    click_on "Edit", match: :first
    assert_selector "h1", text: "Weather Tracker"

    fill_in "Address", with: "Updated Location"
    click_on "Update"

    assert_selector "h1", text: "Weather Tracker"
    assert_text "Updated Location"
  end

  test "Cancelling a Location Update" do
    visit locations_path
    assert_selector "h1", text: "Weather Tracker"

    click_on "Edit", match: :first
    assert_selector "h1", text: "Weather Tracker"

    fill_in "Address", with: "Updated Location"
    click_on "Cancel"

    assert_text "54703"
    assert_text "Updated Location", count: 0
  end

  test "Destroying a location" do
    visit locations_path
    assert_text @location.address

    click_on "Delete", match: :first
    assert_no_text @location.address
  end
end
