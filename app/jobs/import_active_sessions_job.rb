class ImportActiveSessionsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Perform all the DB work in a transaction
    session_json = $mnt.activeSessions()
    sessions = session_json["activeList"]["activeSession"].collect { |session| session.slice("user_name", "calling_station_id", "audit_session_id", "framed_ip_address") }
    sessions.each do |session|
      session["username"] = session.delete "user_name"
      session["mac"] = session.delete "calling_station_id"
      session["ip_address"] = session.delete "framed_ip_address"
    end

    Session.transaction do
      # Remove all sessions
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE sessions RESTART IDENTITY")
      # Recreate new sessions
      sessions.each do |session|
        Session.create!(session)
      end
    end
  end
end
