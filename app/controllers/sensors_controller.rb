class SensorsController < ApplicationController
  skip_before_action :verify_authenticity_token
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
      @sensor = Sensor.create(sensor_id: params[:sensor_id], cleared: false, message_sent: false)
      @response = @sensor.cleared ? 1 : 0
    else
      @sensor = Sensor.where(sensor_id: params[:sensor_id]).last
      if(@sensor)
        @response = @sensor.cleared ? 1 : 0
      else
        @sensor = Sensor.new(sensor_id: params[:sensor_id], cleared: false, message_sent: false)
        @sensor.save
        @response = @sensor.cleared ? 1 : 0
      end
    end
    if(@response == 0 && request.path_parameters[:format] == "json" && @sensor.message_sent == false)
      sid = 'AC06943da31d54a04cb31b29d43e334d57'
      pass = 'e43f19e0772ad1d67ab98d167cd48302'
      # client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
      @matter = url_for(:controller => 'sensors', :action => 'get_details',:sensor_id => @sensor.sensor_id)

      @message  = "Garbage bin: #{@sensor.sensor_id} is almost full. Please clear the bin using the link below. \n"
      @message << "#{view_context.link_to '', @matter}".html_safe

      # msg = "Created job job number #{link_to get_details_sensors_path, :sensor_id => params[:sensor_id]}."
      client = Twilio::REST::Client.new sid, pass
      # msg = "Garbage can almost full. Please clear the bin and use the link to do the same on the website. \n" + request.host_with_port + "/get_details?sensor_id=" + params[:sensor_id]
      message = client.messages.create from: '+14082903859', to: '+14087056411', body: @message
      @sensor.message_sent = true
      @sensor.save
    end
    respond_to do |format|
      format.html
      format.json{render json: @response}
    end
  end

  # def set_details
  #   if(params[:sensor_id])
  #     @sensor = Sensor.create(sensor_id: params[:sensor_id], cleared: false)
  #   end
  #   respond_to do |format|
  #     format.html
  #     format.json{render json: @sensor.cleared}
  #   end
  # end

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
