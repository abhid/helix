require 'redis'

class ProcessWsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    r = Redis.new
    renderer = ::ApplicationController.renderer.new
    while true
      sessions = JSON.parse(r.blpop("stomp:/topic/com.cisco.ise.session")[1])["sessions"]
      # sessions.each do |session|
        html = renderer.render(partial: 'logging/live_row', collection: sessions, as: :session)
        WebServicesChannel.broadcast_to("stomp:/topic/com.cisco.ise.session", html)
      # end
    end
  end
end
