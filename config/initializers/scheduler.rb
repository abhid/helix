require 'rufus-scheduler'
sch = Rufus::Scheduler.singleton

sch.every '5m' do
  # Rails.logger.info "[BACKGROUND] #{Time.now} Running Import Active Sessions..."
  # Rails.logger.flush
  ImportActiveSessionsJob.perform_later
end

sch.every '15m' do
  SyncAznProfileJob.perform_later
  SyncDaclJob.perform_later
  SyncEigJob.perform_later
end

sch.every '30m' do
  SyncNdgJob.perform_later
  SyncNdJob.perform_later
end
