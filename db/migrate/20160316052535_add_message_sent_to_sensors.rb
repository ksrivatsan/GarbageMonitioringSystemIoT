class AddMessageSentToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :message_sent, :boolean
  end
end
