class EndpointGroupsController < ApplicationController
  def index
    @pagy, @endpoint_groups = pagy(EndpointGroup.order(:name).all)
  end

  def show
    @endpoint_group = EndpointGroup.find_by(uuid: params[:id])
    @endpoints = @endpoint_group.endpoints
  end
end
