class Log < ApplicationRecord
  belongs_to :guild

  #methods
  def self.my_new
  	log = Log.new
  	log.data = {}
  	log.message = ""
  	return log
  end
end
