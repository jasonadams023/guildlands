require 'clockwork'
require File.expand_path(__FILE__)+ '/../../config/boot'
require File.expand_path(__FILE__)+ '/../../config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(2.minutes, 'OnTickJob.delay'){OnTickJob.delay.perform_later}

#   every(12.hours, 'Run a job', tz: 'UTC') { ExampleWorker.perform_async }
end

