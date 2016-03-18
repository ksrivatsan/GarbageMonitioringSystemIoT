class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_all_sensors

  def set_all_sensors
  	@sensor_ids = Sensor.all.uniq.pluck(:sensor_id)
  end
end
