class Log < ApplicationRecord
  belongs_to :guild

  #methods
  def self.my_new
  	log = Log.new
  	log.turn = 10
  	#log.turn = Rails.application.config.turn
  	log.data = {}
  	log.message = ""
  	return log
  end
end
