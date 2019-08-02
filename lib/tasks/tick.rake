desc "This task runs the on_tick_job immediately"

task :tick => :environment do
    OnTickJob.perform_now
end