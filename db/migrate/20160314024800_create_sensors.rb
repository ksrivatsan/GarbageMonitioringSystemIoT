class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.integer :sensor_id
      t.boolean :cleared
      t.datetime :cleared_at

      t.timestamps
    end
  end
end
