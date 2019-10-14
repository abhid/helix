class EndpointGroupsController < ApplicationController
  def index
    @pagy, @endpoint_groups = pagy(EndpointGroup.order(:name).all)
  end
end
