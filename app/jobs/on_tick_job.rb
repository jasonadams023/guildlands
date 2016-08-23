class OnTickJob < ApplicationJob
  queue_as :default

  def perform(*args)
    units = Unit.all
    activity = Activity.find(1)
    units.each do |unit|
    	unit.activity = activity
    	unit.save
    end
  end
end
