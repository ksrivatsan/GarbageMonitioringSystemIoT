class NotificationsController < ApplicationController
 
  skip_before_action :verify_authenticity_token
 
  def notify
  	# export TWILIO_ACCOUNT_SID=AC06943da31d54a04cb31b29d43e334d57
  	# export TWILIO_AUTH_TOKEN=e43f19e0772ad1d67ab98d167cd48302
  	ssid = 'AC06943da31d54a04cb31b29d43e334d57'
  	pass = 'e43f19e0772ad1d67ab98d167cd48302'
  	# puts Rails.application.secrets.twilio_account_sid
  	# puts Rails.application.secrets.twilio_auth_token
  	client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
  	client = Twilio::REST::Client.new ssid, pass
  	message = client.messages.create from: '+14082903859', to: '+14087056411', body: 'Garbage bin is almost full. Please clear the bin and click o n the url'

  end
 
end