class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.for_user(current_user).ordered
  end

  def show
    weather = WeatherApi.get_weather(@location.address)

    @has_response = weather != nil

    if @has_response
      @actual_location = "#{weather["location"]["name"]}, #{weather["location"]["region"]}"
      forecast_days = weather["forecast"]["forecastday"]
      @highs = []
      @lows = []
      @days = []

      forecast_days.each do |forecast_day|
        day = {
          high: forecast_day["day"]["maxtemp_f"],
          low: forecast_day["day"]["mintemp_f"],
          condition: forecast_day["day"]["condition"]["text"],
          icon: forecast_day["day"]["condition"]["icon"],
          date: Date.strptime(forecast_day["date"], "%Y-%m-%d").strftime("%A")
        }
        @days.push(day)
        @highs.push({
                      x: day[:date],
                      y:  day[:high]
                    })
        @lows.push({
                     x: day[:date],
                     y:  day[:low]
                   })
      end
    end
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.user = current_user

    if @location.save
      respond_to do |format|
        format.html { redirect_to locations_path, notice: "Location was successfully created." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to locations_path, notice: "Location was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_path, notice: "Location was successfully destroyed."}
      format.turbo_stream
    end


  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:address)
  end
end
