require 'rufus-scheduler'
sch = Rufus::Scheduler.singleton

sch.every '5m' do
  Rails.logger.info "[BACKGROUND] #{Time.now} Running Import Active Sessions..."
  Rails.logger.flush
  ImportActiveSessionsJob.perform_later
end

sch.every '15m' do
  Rails.logger.info "[BACKGROUND] #{Time.now} Running Sync ISE Groups..."
  Rails.logger.flush
  SyncIseGroupsJob.perform_later
end
