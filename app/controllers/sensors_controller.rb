class SensorsController < ApplicationController
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]

  # GET /sensors
  # GET /sensors.json
  def index
    @sensors = Sensor.all
  end

  # GET /sensors/1
  # GET /sensors/1.json
  def show
  end

  # GET /sensors/new
  def new
    @sensor = Sensor.new
  end

  # GET /sensors/1/edit
  def edit
  end

  # GET /sensors/get_details.json
  def get_details
    if(params[:add_new])
      @sensor = Sensor.create(sensor_id: params[:sensor_id], cleared: false)
      @response = @sensor.cleared ? 1 : 0
    else
      @sensor = Sensor.where(sensor_id: params[:sensor_id]).last
      if(@sensor)
        @response = @sensor.cleared ? 1 : 0
      else
        @sensor = Sensor.new(sensor_id: params[:sensor_id], cleared: false)
        @sensor.save
        @response = @sensor.cleared ? 1 : 0
      end
    end
    if(@response == 0){
      ssid = 'AC06943da31d54a04cb31b29d43e334d57'
      pass = 'e43f19e0772ad1d67ab98d167cd48302'
      client = Twilio::REST::Client.new ssid, pass
      message = client.messages.create from: '+14082903859', to: '+14087056411', body: 'Garbage bin is almost full. Please clear the bin and click on the url'.concat(get_details_sensors_path_link(params[:sensor_id]) + ' to reset it to empty.'
    }
    respond_to do |format|
      format.html
      format.json{render json: @response}
    end
  end

  def set_details
    if(params[:sensor_id])
      @sensor = Sensor.create(sensor_id: params[:sensor_id], cleared: false)
    end
    respond_to do |format|
      format.html
      format.json{render json: @sensor.cleared}
    end
  end

  def clear
    @sensor = Sensor.where(sensor_id:params[:sensor_id]).last
    @sensor.cleared = true;
    @sensor.cleared_at = Time.now;
    @sensor.save
    # @sensor_new = Sensor.create(sensor_id: params[:sensor_id], cleared: false)
    redirect_to(@sensor)
  end

  # POST /sensors
  # POST /sensors.json
  def create
    @sensor = Sensor.new(sensor_params)

    respond_to do |format|
      if @sensor.save
        format.html { redirect_to @sensor, notice: 'Sensor was successfully created.' }
        format.json { render :show, status: :created, location: @sensor }
      else
        format.html { render :new }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sensors/1
  # PATCH/PUT /sensors/1.json
  def update
    respond_to do |format|
      if @sensor.update(sensor_params)
        format.html { redirect_to @sensor, notice: 'Sensor was successfully updated.' }
        format.json { render :show, status: :ok, location: @sensor }
      else
        format.html { render :edit }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensors/1
  # DELETE /sensors/1.json
  def destroy
    @sensor.destroy
    respond_to do |format|
      format.html { redirect_to sensors_url, notice: 'Sensor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensor
      @sensor = Sensor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensor_params
      params.require(:sensor).permit(:sensor_id, :cleared, :cleared_at)
    end
end
