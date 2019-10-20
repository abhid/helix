class LoggingController < ApplicationController
  def sessions
    ise_session = Pxgrid::ISE::Session.new($pxgrid)
    @sessions = ise_session.getSessions((Time.now - 1.minutes).iso8601).sort_by { |session| session["timestamp"] }.reverse!
  end

  def radius
    ise_session = Pxgrid::ISE::Radius.new($pxgrid)
    @failures = ise_session.getFailures((Time.now - 1.minutes).iso8601).sort_by { |failure| session["timestamp"] }.reverse!
  end
end
