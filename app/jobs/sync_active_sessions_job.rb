class SyncActiveSessionsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Sync Active Sessions from the MnT API
    session_json = $mnt.activeSessions()
    sessions = session_json["activeList"]["activeSession"].collect { |session| session.slice("user_name", "calling_station_id", "audit_session_id", "framed_ip_address") }

    # Update all sessions
    ActiveRecord::Base.connection.execute("UPDATE sessions SET active = false")
    # Recreate new sessions
    sessions.each do |session|
      ar_session = Session.find_or_create_by(mac: session["calling_station_id"])
      ar_session.active = true
      ar_session.mac = session["calling_station_id"]
      ar_session.username = session["user_name"]
      ar_session.ip_address = session["framed_ip_address"]
      ar_session.audit_session_id = session["audit_session_id"]

      ar_session.save
    end
  end
end
