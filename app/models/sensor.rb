class Sensor < ActiveRecord::Base
	def init
		self.cleared = false
		self.cleared_at = null
	end
end
