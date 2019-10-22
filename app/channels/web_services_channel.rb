class WebServicesChannel < ApplicationCable::Channel
  def subscribed
    stream_for "stomp:/topic/com.cisco.ise.session"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
