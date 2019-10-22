require 'rufus-scheduler'
sch = Rufus::Scheduler.singleton

sch.every '5m', :overlap => false do
  # Rails.logger.info "[BACKGROUND] #{Time.now} Running Import Active Sessions..."
  # Rails.logger.flush
  SyncActiveSessionsJob.perform_later
end

sch.every '15m', :overlap => false do
  SyncAznProfileJob.perform_later
  SyncDaclJob.perform_later
  SyncEigJob.perform_later
end

sch.every '30m', :overlap => false do
  SyncNdgJob.perform_later
  SyncNdJob.perform_later
end

# Keep at this
ProcessWsJob.perform_later
