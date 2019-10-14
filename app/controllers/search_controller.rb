class SearchController < ApplicationController
  def search
    # Search by a MAC / IP / Username
    query = params[:q]

    if query.match? /^([0-9]+(\.)?)+$/
      # Looks like an IP. Just numbers and dots
      @sessions = Session.where("ip_address LIKE ?", "%#{query}%")
    elsif query.match? /[g-zG-Z]*/
      # Not an IP. See if we have anything other than Hex. Search Username.
      @sessions = Session.where("lower(username) LIKE lower(?)", "%#{query}%")
    else
      # Looks like hex
      mac_query = query.gsub(/[^a-fA-F0-9]/, "").upcase.gsub(/(.{2})(?=.)/, '\1:\2')
      @sessions = Session.where("mac LIKE ?", "%#{mac_query}%")
    end
    render json: {sessions: @sessions, endpoints: nil}
  end
end
